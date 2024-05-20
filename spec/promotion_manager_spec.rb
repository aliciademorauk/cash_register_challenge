require 'set'
require_relative '../lib/promotion_manager'
require_relative '../lib/catalogue'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.describe PromotionManager do
  let(:promo_manager) { build(:promotion_manager, :empty) }
  let(:random_code) { build(:catalogue, :with_three_products).products.values.sample.code }

  describe '#add_onexone' do
    context 'when passed valid parameters' do
      it 'adds code to Buy One Get One' do
        promo_manager.add_onexone(random_code)
        expect(promo_manager.active[:onexone]).to include(random_code)
      end

      it 'does not add the same code twice' do
        2.times { promo_manager.add_onexone(random_code) }
        expect(promo_manager.active[:onexone].size).to eq(1)
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
        expect(promo_manager.active[:bulk][conditions]).to include(random_code)
      end

      it 'appends code with the same conditions to the appropriate list' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        promo_manager.add_bulk('XZ9', conditions)
        expect(promo_manager.active[:bulk][conditions].size).to eq(2)
      end

      it 'does not add the same code twice' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.active[:bulk][conditions].size).to eq(1)
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

  describe '#delete' do
    context 'when promotion exists' do
      it 'deletes the promotion from Buy One Get One' do
        promo_manager.add_onexone(random_code)
        expect(promo_manager.delete(random_code)).to be_truthy
        expect(promo_manager.find(random_code)).to be_falsey
      end

      it 'deletes the promotion from Bulk Buy' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.delete(random_code)).to be_truthy
        expect(promo_manager.find(random_code)).to be_falsey
      end
    end

    context 'when promotion does not exist' do
      it 'returns false' do
        expect(promo_manager.delete('non_existent_code')).to be_falsey
      end
    end
  end

  describe '#list' do
    context 'when there are no active promotions' do
      it 'returns a message indicating no promotions' do
        expect(promo_manager.list).to eq('No active promotions available.')
      end
    end

    context 'when there are active promotions' do
      it 'lists all Buy One Get One promotions' do
        promo_manager.add_onexone(random_code)
        expect(promo_manager.list).to include("Buy One Get One Free: #{random_code}")
      end

      it 'lists all Bulk Buy promotions' do
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk(random_code, conditions)
        expect(promo_manager.list).to include("Buy #{conditions[:min_qty]} Get #{conditions[:disc]}% Off: #{random_code}")
      end

      it 'lists mixed promotions correctly' do
        promo_manager.add_onexone(random_code)
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk('XZ9', conditions)
        expect(promo_manager.list).to include("Buy One Get One Free: #{random_code}", "Buy #{conditions[:min_qty]} Get #{conditions[:disc]}% Off: XZ9")
      end
    end
  end
end
