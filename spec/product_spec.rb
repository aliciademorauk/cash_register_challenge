require_relative '../lib/product'

RSpec.describe Product do
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
        it 'invalidates lowercase letters' do
          expect(Product.attr_validated?(:name, 'grEen teA')).to be_falsey
        end
        it 'invalidates trailing whitespaces' do
          expect(Product.attr_validated?(:name, 'STRAWBERRIES ')).to be_falsey
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
        it 'invalidates lowercase letters' do
          expect(Product.attr_validated?(:code, 'gr1')).to be_falsey
        end
        it 'invalidates trailing whitespaces' do
          expect(Product.attr_validated?(:code, ' GR1 ')).to be_falsey
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

        it 'invalidates whitespace in between' do
          expect(Product.attr_validated?(:code, 'CF 1')).to be_falsey
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
        it 'invalidates trailing whitespaces' do
          expect(Product.attr_validated?(:price, ' 1 ')).to be_falsey
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
