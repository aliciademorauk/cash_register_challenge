require_relative 'product'
require_relative 'services/money_converter'

class Catalogue
  include MoneyConverter
  attr_reader :products

  def initialize
    @products = {}
  end

  def find(code)
    @products[code]
  end

  def add(name, code, price)
    find(code) ? nil : @products[code] = Product.new(name: name, code: code, price: price)
  end

  def delete(code)
    @products.delete(code)
  end

  def list
    @products.empty? ? 'No products available.' : @products.map { |code, product|
      price = to_main_unit(product.price_in_cents)
      "#{product.name} [#{code}]: #{price}"
    }.join("\n")
  end

end