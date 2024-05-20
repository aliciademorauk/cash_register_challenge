require_relative '../lib/product'

RSpec.describe Product do
  describe '#to_cents' do 
    let(:product) { -> (price) { Product.new(name: 'GREEN TEA', code: 'GR1', price: price) } }
    context 'when used to set price attribute in #initialize' do
      it 'sets price in cents as an Integer' do
        expect(product.call(3.11).price_in_cents).to eq(311)
      end
      it 'sets price for whole number correctly' do
        expect(product.call(5).price_in_cents).to eq(500)
      end
      it 'sets price for string representation of a number correctly' do
        expect(product.call('123').price_in_cents).to eq(12300)
      end
      it 'would convert negative price' do
        expect(product.call(-3.11).price_in_cents).to eq(-311)
      end
      it 'would convert zero correctly' do
        expect(product.call(0).price_in_cents).to eq(0)
      end
      it 'would prevent initialization for non-numeric string' do
        expect { product.call('abc').price_in_cents }.to raise_error(ArgumentError)
      end
      it 'would prevent initialization for whitespace only string' do
        expect { product.call('   ').price_in_cents }.to raise_error(ArgumentError)
      end
    end
  end
end
