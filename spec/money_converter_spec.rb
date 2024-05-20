require_relative '../lib/services/money_converter'

RSpec.describe MoneyConverter do
  include MoneyConverter

  describe '.to_main_unit' do
    it 'converts cents to euros correctly' do
      expect(to_main_unit(50)).to eq('0.50')
    end
    it 'converts cents in string form to euros correctly' do
      expect(to_main_unit('50')).to eq('0.50')
    end
    it 'adds leading zeros when needed' do
      expect(to_main_unit(1)).to eq('0.01')
    end
  end

  describe '.to_cents' do
    it 'converts main unit to cents correctly' do
      expect(to_cents(0.50)).to eq(50)
    end
    it 'handles whole numbers correctly' do
      expect(to_cents('2')).to eq(200)
    end
    it 'handles large numbers correctly' do
      expect(to_cents(1234.56)).to eq(123456)
    end
    it 'handles zero main unit correctly' do
      expect(to_cents('0.00')).to eq(0)
    end
    it 'handles negative main unit correctly' do
      expect(to_cents('-0.50')).to eq(-50)
    end
    it 'handles input with extra decimal places correctly' do
      expect(to_cents('0.501')).to eq(50) # Round down
      expect(to_cents('0.509')).to eq(50) # Round down
      expect(to_cents('0.511')).to eq(51) # Round up
    end
  end
end
