require 'bigdecimal'

module MoneyConverter

  # Method to convert from cents to main unit to print to user. Returns String.
  def to_main_unit(cents)
    cents_str = cents.to_s
    sprintf('%.2f', (BigDecimal(cents_str) / 100))
  end

  # Method to convert to cents when input is taken from user. For calculations and storage.
  def to_cents(main_unit)
    main_str = main_unit.to_s
    (BigDecimal(main_str) * 100).to_i
  end

end