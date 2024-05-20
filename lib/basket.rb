require_relative 'catalogue'
require_relative 'services/money_converter'

class Basket
  include MoneyConverter

  attr_reader :items

  def initialize
    @items = {} # code => {:name, :price_in_cents, :quantity}
    @subtotal = 0
  end

  def add(code, catalogue)
    product = catalogue.find(code)
    unless product.nil?
      code = product.code
      item = @items[code]
      item ? item[:quantity] += 1 : @items[code] = { name: product.name, price_in_cents: product.price_in_cents, quantity: 1 }
      @subtotal += product.price_in_cents
    end
    product
  end

  def get_subtotal
    to_main_unit(@subtotal)
  end

  def list
    @items.map do |code, details|
      price = to_main_unit(details[:price_in_cents])
      "#{details[:name]} [#{code}] #{details[:quantity]} x #{price}"
    end.join("\n")
  end 

end