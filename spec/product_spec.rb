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

  describe '.attr_validated?' do
    context 'when called with valid key-value pairs' do
      context 'when called with valid name value' do
        it 'validates single character' do
          expect(Product.attr_validated?(:name, '7')).to be_truthy
        end
        it 'validates whitespace in between' do
          expect(Product.attr_validated?(:name, 'GREEN TEA')).to be_truthy
        end
      end
      
      context 'when called with invalid name value' do
        it 'invalidates whitespaces not in-between' do
          expect(Product.attr_validated?(:name, 'STRAWBERRIES ')).to be_falsey
        end
        it 'invalidates lowercase letters' do
          expect(Product.attr_validated?(:name, 'grEen teA')).to be_falsey
        end
        it 'invalidates symbols' do
          expect(Product.attr_validated?(:name, '*GREEN TEA*')).to be_falsey
        end
      end

      context 'when called with valid code value' do
        it 'validates a one letter one number' do
          expect(Product.attr_validated?(:code, 'A1')).to be_truthy
        end

        it 'validates a combination of 4 letters followed by 4 numbers' do
          expect(Product.attr_validated?(:code, 'ABCD1234')).to be_truthy
        end
      end

      context 'when called with invalid code value' do
        it 'invalidates whitespaces' do
          expect(Product.attr_validated?(:code, ' CF1 ')).to be_falsey
        end
        it 'invalidates whitespaces in between' do
          expect(Product.attr_validated?(:code, 'CF 1')).to be_falsey
        end
        it 'invalidates lowercase letters' do
          expect(Product.attr_validated?(:code, 'gr1')).to be_falsey
        end
        it 'invalidates only numbers' do
          expect(Product.attr_validated?(:code, '1')).to be_falsey
        end

        it 'invalidates only letters' do
          expect(Product.attr_validated?(:code, 'ABCD')).to be_falsey
        end

        it 'invalidates special symbols' do
          expect(Product.attr_validated?(:code, 'SR#1')).to be_falsey
        end

        it 'invalidates more than eight chars' do
          expect(Product.attr_validated?(:code, 'ABCDE12345')).to be_falsey
        end
      end

      context 'when called with valid price value' do
        it 'validates price with one decimal place' do
          expect(Product.attr_validated?(:price, '5.0')).to be_truthy
        end

        it 'validates price less than one' do
          expect(Product.attr_validated?(:price, '0.99')).to be_truthy
        end
      end

      context 'when called with invalid price value' do
        it 'invalidates whitespaces' do
          expect(Product.attr_validated?(:price, ' 1 ')).to be_falsey
        end
        it 'invalidates whitespaces in between' do
          expect(Product.attr_validated?(:price, '1 2')).to be_falsey
        end
        it 'invalidates zero' do
          expect(Product.attr_validated?(:price, '0')).to be_falsey
        end

        it 'invalidates zero expressed with decimals' do
          expect(Product.attr_validated?(:price, '0.00')).to be_falsey
        end

        it 'invalidates no digits before the dot' do
          expect(Product.attr_validated?(:price, '.99')).to be_falsey
        end

        it 'invalidates above 9999' do
          expect(Product.attr_validated?(:price, '10000')).to be_falsey
        end

        it 'invalidates more than two decimals' do
          expect(Product.attr_validated?(:price, '5.000')).to be_falsey
        end

        it 'invalidates non-numeric characters' do
          expect(Product.attr_validated?(:price, '5.0a')).to be_falsey
        end

        it 'invalidates non-numeric characters only' do
          expect(Product.attr_validated?(:price, 'aaa')).to be_falsey
        end

        it 'invalidates commas' do
          expect(Product.attr_validated?(:price, '5,00')).to be_falsey
        end

        it 'invalidates symbols' do
          expect(Product.attr_validated?(:price, '$5.00')).to be_falsey
        end

        it 'invalidates whitespace in between' do
          expect(Product.attr_validated?(:price, '5. 00')).to be_falsey
        end
      end
    end

    context 'when called with invalid key-value pairs' do
      context 'when value is nil' do
        it 'returns nil' do
          expect(Product.attr_validated?(:name, nil)).to be_nil
        end
      end
  
      context 'when key is nil' do
        it 'fails' do
          expect { Product.attr_validated?(nil, 'STRAWBERRIES') }.to raise_error(TypeError)
        end
      end
  
      context 'when key is not valid' do
        it 'fails' do
          expect { Product.attr_validated?(:unknown_key, 'STRAWBERRIES') }.to raise_error(TypeError)
        end
      end
  
      context 'when key is not a symbol' do
        it 'fails' do
          expect { Product.attr_validated?('name', 'STRAWBERRIES') }.to raise_error(TypeError)
        end
      end
    end
  end
end
