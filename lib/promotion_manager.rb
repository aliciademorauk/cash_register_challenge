require 'set'

class PromotionManager
  
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
