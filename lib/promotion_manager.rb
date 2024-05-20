require 'set'

class PromotionManager

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
  
  def initialize
    @active = { 
      onexone: Set.new, # onexone: ['GR1']
      bulk: {} # bulk: { { min_qty: 3, disc: 33 } => ['CF1'], { min_qty: 5, disc: 10 } => ['SR1'] } 
    }
  end

  def find(code)
    return (
      @active[:onexone].include?(code) || @active[:bulk].any? { |_, codes| codes.include?(code) }
    )
  end

  def add_onexone(code)
    @active[:onexone].add(code)
  end

  def add_bulk(code, conditions) 
    @active[:bulk][conditions] ||= []
    @active[:bulk][conditions] << code unless @active[:bulk][conditions].include?(code)
  end
  
end
