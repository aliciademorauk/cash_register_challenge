require 'set'
require_relative '../lib/promotion_manager'
require_relative '../lib/catalogue'

RSpec.describe PromotionManager do
  let(:promo_manager) { build(:promotion_manager, :empty) }
  let(:random_code) { (build(:catalogue, :with_three_products).products.values.sample).code }

  describe '#add_onexone' do
    context 'when passed valid parameters' do
      it 'adds code to Buy One Get One' do
        promo_manager.add_onexone(random_code)
        expect(promo_manager.instance_variable_get(:@active)[:onexone]).to include(random_code)
      end
      it 'does not add the same code twice' do
        2.times { promo_manager.add_onexone(random_code) }
        expect(promo_manager.instance_variable_get(:@active)[:onexone].size).to eq(1)
      end
    end
    context 'when passed invalid parameters' do
      it 'does not raise an error when passed nil' do
        expect { promo_manager.add_onexone(nil) }.not_to raise_error
      end
    end
  end

  describe '#add_bulk' do
    context 'when passed valid parameters' do
      it 'sets code to promotion conditions key' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.instance_variable_get(:@active)[:bulk][conditions]).to include(random_code)
      end
      it 'appends code with the same conditions to the appropriate list' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        promo_manager.add_bulk('XZ9', conditions)
        expect(promo_manager.instance_variable_get(:@active)[:bulk][conditions].size).to eq(2)
      end
      it 'does not add the same code twice' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.instance_variable_get(:@active)[:bulk][conditions].size).to eq(1)
      end
    end
    context 'when passed invalid parameters' do
      it 'does not raise an error when passed nil' do
        conditions = { min_qty: 5, disc: 10 }
        expect { promo_manager.add_bulk(nil, conditions) }.not_to raise_error
      end
    end
  end

  describe '#find' do
    context 'when passed valid parameters' do
      it 'returns true if Buy One Get One found' do
        promo_manager.add_onexone(random_code)
        expect(promo_manager.find(random_code)).to be_truthy
      end
      it 'returns true if Bulk Buy found' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.find(random_code)).to be_truthy
      end
      it 'returns false if Buy One Get One not found' do
        expect(promo_manager.find(random_code)).to be_falsey
      end
      it 'returns false if Bulk Buy not found' do
        expect(promo_manager.find(random_code)).to be_falsey
      end
    end
    context 'when passed invalid parameters' do
      it 'returns false when trying to find a nil code' do
        expect(promo_manager.find(nil)).to be_falsey
      end
      it 'returns false when trying to find an empty string code' do
        expect(promo_manager.find('')).to be_falsey
      end
    end
  end
end