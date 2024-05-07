require 'product.rb'

RSpec.describe Product do

  it 'creates a Product object' do
    product = Product.new
    expect(product).to be_kind_of(Product)
  end
end
