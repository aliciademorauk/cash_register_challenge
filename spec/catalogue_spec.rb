require_relative '../lib/product'
require_relative '../lib/catalogue'

RSpec.describe Catalogue do
  let(:catalogue_one) { build(:catalogue, :with_one_product) }
  let(:catalogue_two) { build(:catalogue, :with_two_products) }
  let(:green_tea) { build(:product, :green_tea) }
  let(:coffee) { build(:product, :coffee) }
  let(:strawberries) { build(:product, :strawberries) }

  describe '#find' do
    it 'returns product if code matches' do
      expect(catalogue_one.find(green_tea.code)).to have_attributes(
        name: green_tea.name, 
        code: green_tea.code, 
        price_in_cents: green_tea.price_in_cents
      )
    end
    it 'returns nil if match is not found' do
      expect(catalogue_one.find(strawberries.code)).to be_nil
    end
  end

  describe '#add' do
    it 'adds new product' do
      catalogue_one.add(strawberries.name, strawberries.code, 5) 
      expect(catalogue_one.products[strawberries.code]).to have_attributes(
        name: strawberries.name, 
        code: strawberries.code, 
        price_in_cents: strawberries.price_in_cents
      )
    end
    it 'adds multiple unique products' do
      catalogue_one.add(strawberries.name, strawberries.code, 5) 
      catalogue_one.add(coffee.name, coffee.code, 11.23) 
      [strawberries, green_tea, coffee].each do |product|
        expect(catalogue_one.products.values).to include(
          have_attributes(name: product.name, code: product.code, price_in_cents: product.price_in_cents)
        )
      end
    end
    it 'prevents entry if product already exists' do
      expect(catalogue_one.add(green_tea.name, green_tea.code, 3.11)).to be_nil
    end
    it 'prevents entry if code is matched to already existing product' do
      expect(catalogue_one.add('Green Tea Bag', green_tea.code, 3.11)).to be_nil
    end
  end

  describe '#delete' do
    it 'deletes existing product' do
      catalogue_two.delete(green_tea.code)
      expect(catalogue_two.products).not_to have_key('GR1')
    end
    it 'deletes multiple unique products' do
      catalogue_two.delete(green_tea.code)
      catalogue_two.delete(strawberries.code)
      expect(catalogue_two.products).to be_empty
    end
    it 'returns nil if product is not found' do
      expect(catalogue_two.delete(coffee.code)).to be_nil
    end
    it 'returns nil if code is nil' do
      expect(catalogue_two.delete(nil)).to be_nil
    end
  end

  describe '#list' do
    context 'when the catalogue is empty' do
      it 'returns informative string' do
        empty_catalogue = build(:catalogue, :empty_catalogue)
        expect(empty_catalogue.list).to eq('No products available.')
      end
    end

    context 'when the catalogue is not empty' do
      it 'returns correct details for multiple products in string' do
        expect(catalogue_two.list).to eq("GREEN TEA [GR1]: 3.11\nSTRAWBERRIES [SR1]: 5.00")
      end
    end
  end
end
