require 'product.rb'

RSpec.describe Product do
  context 'when initialized with valid attributes' do
    subject(:product) { Product.new('Strawberries', 'SR1', 5) }

    it 'is an instance of Product' do
      expect(product).to be_kind_of(Product)
    end

    it 'sets the name attribute' do
      expect(product.name).to eq('Strawberries')
    end

    it 'sets the product_code attribute' do
      expect(product.product_code).to eq('SR1')
    end

    it 'sets the price attribute' do
      expect(product.price).to eq(5)
    end
  end
end

