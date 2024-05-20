FactoryBot.define do
  factory :basket do
    initialize_with { new }

    trait :with_green_tea do
      after(:build) do |basket, evaluator|
        catalogue = build(:catalogue, :with_one_product)
        product = catalogue.find('GR1')
        basket.add(product.code, catalogue)
      end
    end

    trait :empty do
    end
  end
end
