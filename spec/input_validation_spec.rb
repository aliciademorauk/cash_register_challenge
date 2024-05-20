require_relative '../lib/services/input_validation'
require_relative '../lib/product'
require_relative '../lib/promotion_manager'

RSpec.describe InputValidation do 
  include InputValidation

  describe '.validated?' do
    context 'when called with valid key-value pairs' do
      context 'when called to validate Product attributes' do
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

      context 'when called to validate Promotion conditions inputs' do
        context 'when validating :min_q' do
          it 'validates integer between 2 and 9' do
            (2..9).each do |valid_value|
              expect(validated?(:min_q, valid_value, PromotionManager::INPUT_VAL_RULES)).to be_truthy
            end
          end
    
          it 'invalidates integers outside the range 2 to 9' do
            [0, 1, 10, 11].each do |invalid_value|
              expect(validated?(:min_q, invalid_value, PromotionManager::INPUT_VAL_RULES)).to be_falsey
            end
          end
    
          it 'invalidates non-integer values' do
            ['a', '1.5', '10.5', ''].each do |invalid_value|
              expect(validated?(:min_q, invalid_value, PromotionManager::INPUT_VAL_RULES)).to be_falsey
            end
          end
        end
    
        context 'when validating :disc' do
          it 'validates integer between 5 and 90 inclusive' do
            valid_values = (5..9).to_a + (10..89).to_a + [90]
            valid_values.each do |valid_value|
              expect(validated?(:disc, valid_value, PromotionManager::INPUT_VAL_RULES)).to be_truthy
            end
          end
    
          it 'invalidates integers outside the range 5 to 90' do
            [0, 1, 4, 91, 100].each do |invalid_value|
              expect(validated?(:disc, invalid_value, PromotionManager::INPUT_VAL_RULES)).to be_falsey
            end
          end
    
          it 'invalidates non-integer values' do
            ['a', '5.5', '100.1', ''].each do |invalid_value|
              expect(validated?(:disc, invalid_value, PromotionManager::INPUT_VAL_RULES)).to be_falsey
            end
          end
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
          expect { validated?(nil, 5, PromotionManager::INPUT_VAL_RULES) }.to raise_error(TypeError)
        end
      end
  
      context 'when key is not valid' do
        it 'fails' do
          expect { validated?(:unknown_key, 'STRAWBERRIES', Product::INPUT_VAL_RULES) }.to raise_error(TypeError)
        end
      end
  
      context 'when key is not a symbol' do
        it 'fails' do
          expect { validated?('min_q', 5, PromotionManager::INPUT_VAL_RULES) }.to raise_error(TypeError)
        end
      end
    end
  end
end
