class Product
  attr_reader :name, :product_code, :price

  def initialize(name:, code:, price:)
    @name = name
    @product_code = code
    @price = price
  end
end