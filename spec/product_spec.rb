require 'product.rb'

RSpec.describe Product do
  describe '#initialize' do 
    context 'with all keyword arguments' do
      subject(:product) { 
        Product.new(name: 'Strawberries', code: 'SR1', price: 5) 
      }
      it 'creates an instance of Product' do
        expect(product).to be_kind_of(Product)
      end

      it 'sets the name attribute' do
        expect(product.name).to eq('Strawberries')
      end

      it 'sets the code attribute' do
        expect(product.product_code).to eq('SR1')
      end

      it 'sets the price attribute' do
        expect(product.price).to eq(5)
      end
    end

    context 'without any keyword arguments' do
      it 'raises an ArgumentError' do
        expect { Product.new('Strawberries', 'SR1', 5) }.to raise_error(ArgumentError)
      end
    end

    context 'with one keyword argument missing' do
      it 'raises an ArgumentError' do
        expect { Product.new(name: 'Strawberries', code: 'SR1') }.to raise_error(ArgumentError)
      end
    end

    context 'with no arguments at all' do
      it 'raises an ArgumentError' do
        expect { Product.new }.to raise_error(ArgumentError)
      end
    end
  end
end

