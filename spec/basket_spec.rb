require_relative '../lib/catalogue'
require_relative '../lib/services/money_converter'
require_relative '../lib/basket'

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