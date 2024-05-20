require 'factory_bot'

FactoryBot.define do
  factory :product do

    trait :green_tea do
      name { 'GREEN TEA' }
      code { 'GR1' }
      price { 3.11 }
    end

    trait :strawberries do
      name { 'STRAWBERRIES' }
      code { 'SR1' }
      price { 5 }
    end

    trait :coffee do
      name { 'COFFEE' }
      code { 'CF1' }
      price { 11.23 }
    end

    initialize_with { new(name: name, code: code, price: price) }
  end
end
