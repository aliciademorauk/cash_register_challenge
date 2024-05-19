require 'bigdecimal'

class Product
  attr_reader :name, :code, :price_in_cents

  INPUT_VAL_RULES = {
    name: /\A[A-Z0-9]+(?:\s[A-Z0-9]+)*\z/, # At least 1 alphanumeric char, letters upcased, no symbols
    code: /\A[A-Z]{1,4}\d{1,4}\z/, # 1-4 letters (upcased) followed by 1-4 digits, no symbols or whitespace
    price: /^(?!0+$|0+\.0+$)\d{1,4}(\.\d{1,2})?$/ # 1-4 digits before decimal, up to 2 decimal places separated by periods (no commas allowed)
  }

  def initialize(name:, code:, price:)
    @name = name
    @code = code
    @price_in_cents = to_cents(price)
  end

  def self.attr_validated?(key, value)
    value.to_s.match(INPUT_VAL_RULES[key])
  end

  private

  def to_cents(main_unit)
    main_str = main_unit.to_s
    (BigDecimal(main_str) * 100).to_i
  end
end