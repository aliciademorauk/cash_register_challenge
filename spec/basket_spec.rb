require_relative '../lib/basket'
require_relative '../lib/catalogue'
require_relative '../lib/promotion_manager'
require_relative '../lib/services/money_converter'

RSpec.describe Basket do
  include MoneyConverter

  let(:empty_basket) { build(:basket, :empty) }
  let(:basket_gt) { build(:basket, :with_green_tea) }
  let(:basket_gt_cf) { build(:basket, :with_two_gt_and_two_cf) }
  let(:complete_catalogue) { build(:catalogue, :with_three_products) } 
  let(:empty_catalogue) { build(:catalogue, :empty) }
  let(:random_product) { complete_catalogue.products.values.sample }
  let(:coffee) { build(:product, :coffee) }
  let(:strawberries) { build(:product, :strawberries) }


  describe '#add' do
    it 'adds item to empty basket' do
      empty_basket.add(random_product.code, complete_catalogue)
      expect(empty_basket.items).to include(random_product.code => { 
        name: random_product.name, price_in_cents: random_product.price_in_cents, quantity: 1 
      })
    end
    it 'adds new item in basket' do
      basket_gt.add(coffee.code, complete_catalogue)
      expect(basket_gt.items).to include(coffee.code => { 
        name: coffee.name, price_in_cents: coffee.price_in_cents, quantity: 1 
      })
    end
    it 'increases quantity of existing item in basket' do
      2.times { empty_basket.add(random_product.code, complete_catalogue) }
      expect(empty_basket.items[random_product.code][:quantity]).to eq(2)
    end
    it 'updates basket subtotal' do
      empty_basket.add(random_product.code, complete_catalogue)
      expect(empty_basket.get_subtotal).to eq(to_main_unit(random_product.price_in_cents))
    end
    it 'does not add product with non-existent code' do
      expect { basket_gt.add('unknown', complete_catalogue) }.not_to change { basket_gt.items }
    end
    it 'returns nil for product with non-existent code' do
      expect(basket_gt.add('unknown', complete_catalogue)).to be_nil
    end
    it 'does not add product if the catalogue is empty' do 
      expect { basket_gt.add(random_product.code, empty_catalogue) }.not_to change { basket_gt.items }
    end
  end

  describe '#get_subtotal' do
    it 'returns "0.00" when basket is empty' do
      expect(empty_basket.get_subtotal).to eq('0.00')
    end
    it 'returns correct subtotal for a single item' do
      empty_basket.add(coffee.code, complete_catalogue)
      expected_subtotal = to_main_unit(coffee.price_in_cents)
      expect(empty_basket.get_subtotal).to eq(expected_subtotal)
    end
    it 'returns correct subtotal for multiple items' do
      basket_gt_cf
      expected_subtotal = to_main_unit(basket_gt_cf.items.values.sum { |item| item[:price_in_cents] * item[:quantity] })
      expect(basket_gt_cf.get_subtotal).to eq(expected_subtotal)
    end
  end

  describe '#get_total' do
    context 'without promotions' do
      let(:promo_manager) { build(:promotion_manager, :empty) }
      it 'returns the subtotal when there are no promotions' do
        total = basket_gt.get_total(promo_manager)
        expect(total).to eq(to_main_unit(basket_gt.items.values.sum { |item| item[:price_in_cents] * item[:quantity] }))
      end
    end

    context 'with Buy One Get One promotion' do
      let(:promo_manager) { build(:promotion_manager, :with_onexone_promotion) }
      let(:basket) { build(:basket, :with_green_tea) }

      it 'gets correct total for even quantity' do
        basket.add('GR1', complete_catalogue)
        total = basket.get_total(promo_manager)
        expected_total = to_main_unit(basket.items['GR1'][:price_in_cents] * 2 - promo_manager.get_savings(basket.items))
        expect(total).to eq(expected_total)
      end
      it 'gets correct total for odd quantity' do
        2.times { basket.add('GR1', complete_catalogue) }
        total = basket.get_total(promo_manager)
        expected_total = to_main_unit(basket.items['GR1'][:price_in_cents] * 3 - promo_manager.get_savings(basket.items))
        expect(total).to eq(expected_total)
      end
    end

    context 'with Bulk Buy promotion' do
      let(:promo_manager) { build(:promotion_manager, :with_bulk_promotion) }
      let(:basket) { build(:basket, :with_two_gt_and_two_cf) }

      it 'calculates correct total when quantity meets the minimum requirement' do
        3.times { basket.add('CF1', complete_catalogue) }
        total = basket.get_total(promo_manager)
        expected_total = to_main_unit(basket.items.values.sum { |item| item[:price_in_cents] * item[:quantity] } - promo_manager.get_savings(basket.items))
        expect(total).to eq(expected_total)
      end
      it 'calculates zero discount when quantity is less than the minimum requirement' do
        2.times { basket.add('CF1', complete_catalogue) }
        total = basket.get_total(promo_manager)
        expected_total = to_main_unit(basket.items.values.sum { |item| item[:price_in_cents] * item[:quantity] })
        expect(total).to eq(expected_total)
      end
    end
  end

  describe '#list' do
    context 'when it contains items' do
      it 'returns different items on different lines' do
        expect(basket_gt_cf.list).to eq("GREEN TEA [GR1] 2 x 3.11\nCOFFEE [CF1] 2 x 11.23")
      end
    end

    context 'when empty' do
      it 'returns an empty string' do
        expect(empty_basket.list).to eq('')
      end
    end
  end
end