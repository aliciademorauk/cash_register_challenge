class Product
  attr_reader :name, :product_code, :price

  def initialize(name, product_code, price)
    @name = name
    @product_code = product_code
    @price = price
  end
end