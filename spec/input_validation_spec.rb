require_relative '../lib/services/input_validation'
require_relative '../lib/product'

RSpec.describe InputValidation do 
  include InputValidation

  describe '.validated?' do
    context 'when called to validate Product attributes' do
      context 'when called with valid key-value pairs' do
        context 'when called with valid name value' do
          it 'validates single character' do
            expect(validated?(:name, '7', Product::INPUT_VAL_RULES)).to be_truthy
          end
          it 'validates whitespace in between' do
            expect(validated?(:name, 'GREEN TEA', Product::INPUT_VAL_RULES)).to be_truthy
          end
        end
        
        context 'when called with invalid name value' do
          it 'invalidates whitespaces not in-between' do
            expect(validated?(:name, 'STRAWBERRIES ', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates lowercase letters' do
            expect(validated?(:name, 'grEen teA', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates symbols' do
            expect(validated?(:name, '*GREEN TEA*', Product::INPUT_VAL_RULES)).to be_falsey
          end
        end

        context 'when called with valid code value' do
          it 'validates a one letter one number' do
            expect(validated?(:code, 'A1', Product::INPUT_VAL_RULES)).to be_truthy
          end
          it 'validates a combination of 4 letters followed by 4 numbers' do
            expect(validated?(:code, 'ABCD1234', Product::INPUT_VAL_RULES)).to be_truthy
          end
        end

        context 'when called with invalid code value' do
          it 'invalidates whitespaces' do
            expect(validated?(:code, ' CF1 ', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates whitespaces in between' do
            expect(validated?(:code, 'CF 1', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates lowercase letters' do
            expect(validated?(:code, 'gr1', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates only numbers' do
            expect(validated?(:code, '1', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates only letters' do
            expect(validated?(:code, 'ABCD', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates special symbols' do
            expect(validated?(:code, 'SR#1', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates more than eight chars' do
            expect(validated?(:code, 'ABCDE12345', Product::INPUT_VAL_RULES)).to be_falsey
          end
        end

        context 'when called with valid price value' do
          it 'validates price with one decimal place' do
            expect(validated?(:price, '5.0', Product::INPUT_VAL_RULES)).to be_truthy
          end
          it 'validates price less than one' do
            expect(validated?(:price, '0.99', Product::INPUT_VAL_RULES)).to be_truthy
          end
        end

        context 'when called with invalid price value' do
          it 'invalidates whitespaces' do
            expect(validated?(:price, ' 1 ', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates whitespaces in between' do
            expect(validated?(:price, '1 2', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates zero' do
            expect(validated?(:price, '0', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates zero expressed with decimals' do
            expect(validated?(:price, '0.00', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates no digits before the dot' do
            expect(validated?(:price, '.99', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates above 9999' do
            expect(validated?(:price, '10000', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates more than two decimals' do
            expect(validated?(:price, '5.000', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates non-numeric characters' do
            expect(validated?(:price, '5.0a', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates non-numeric characters only' do
            expect(validated?(:price, 'aaa', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates commas' do
            expect(validated?(:price, '5,00', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates symbols' do
            expect(validated?(:price, '$5.00', Product::INPUT_VAL_RULES)).to be_falsey
          end
          it 'invalidates whitespace in between' do
            expect(validated?(:price, '5. 00', Product::INPUT_VAL_RULES)).to be_falsey
          end
        end
      end

      context 'when called with invalid key-value pairs' do
        context 'when value is nil' do
          it 'returns nil' do
            expect(validated?(:name, nil, Product::INPUT_VAL_RULES)).to be_nil
          end
        end
    
        context 'when key is nil' do
          it 'fails' do
            expect { validated?(nil, 'STRAWBERRIES', Product::INPUT_VAL_RULES) }.to raise_error(TypeError)
          end
        end
    
        context 'when key is not valid' do
          it 'fails' do
            expect { validated?(:unknown_key, 'STRAWBERRIES', Product::INPUT_VAL_RULES) }.to raise_error(TypeError)
          end
        end
    
        context 'when key is not a symbol' do
          it 'fails' do
            expect { validated?('name', 'STRAWBERRIES', Product::INPUT_VAL_RULES) }.to raise_error(TypeError)
          end
        end
      end
    end
  end
end
