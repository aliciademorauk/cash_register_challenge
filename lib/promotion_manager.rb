require 'set'

class PromotionManager
  attr_reader :active

  # Stores input validation when the user adds a new promotion (if input validation is needed).
  INPUT_VAL_RULES = {
    min_q: /^[2-9]$/, # Integer between 2 and 9 (inclusive)
    disc: /^(?:[5-9]|[1-8][0-9]|90)$/ # Integer between 5 and 90 (inclusive)
  }

  # Stores the promotion rules - Buy One Get One; Bulk Buy Discount.
  PROMO_PROCS = {
    onexone: proc { |p, q| q >= 2 ? q / 2 * p : 0 },
    bulk: proc { |p, q, min_q, disc| q >= min_q ? (p * q * disc) / 100 : 0 }
  }
  
  # onexone: ['GR1'] & bulk: { { min_qty: 3, disc: 33 } => ['CF1'], { min_qty: 5, disc: 10 } => ['SR1'] } 
  def initialize
    @active = { onexone: Set.new, bulk: {} }
  end

  def find(code)
    return (@active[:onexone].include?(code) || @active[:bulk].any? { |_, codes| codes.include?(code) })
  end

  def add_onexone(code)
    @active[:onexone].add(code)
  end

  def add_bulk(code, conditions) 
    @active[:bulk][conditions] ||= []
    @active[:bulk][conditions] << code unless @active[:bulk][conditions].include?(code)
  end

  def delete(code)
    @active[:onexone].delete?(code) || 
    @active[:bulk].any? do |conditions, codes|
      if codes.delete(code)
        @active[:bulk].delete(conditions) if codes.empty?
        true
      end
    end
  end

  def list
    output = []
    onexone_promos = @active[:onexone]
    output << "Buy One Get One Free: #{onexone_promos.to_a.join(', ')}" unless onexone_promos.empty?
    @active[:bulk].each do |conditions, codes|
      unless codes.empty?
        output << "Buy #{conditions[:min_qty]} Get #{conditions[:disc]}% Off: #{codes.join(', ')}"
      end
    end
    output.empty? ? 'No active promotions available.' : output.join("\n")
  end

  def get_savings(items)
    discount = 0
    items.each do |code, item|
      type = get_type(code)
      unless type.nil?
        p = item[:price_in_cents]
        q = item[:quantity]
        case type
        when :onexone
          discount += PROMO_PROCS[:onexone].call(p, q)
        when Hash
          discount += PROMO_PROCS[:bulk].call(
            p, q, min_qty = type[:conditions][:min_qty], disc = type[:conditions][:disc]
          )
        end
      end
    end
    discount
  end

  private 

  def get_type(code)
    return :onexone if @active[:onexone].include?(code)
    @active[:bulk].each do |conditions, codes|
      return { type: :bulk, conditions: conditions } if codes.include?(code)
    end
    nil
  end

end
