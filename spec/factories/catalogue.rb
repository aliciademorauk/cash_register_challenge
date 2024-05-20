FactoryBot.define do
  factory :catalogue do
    transient do
      promotion_manager { build(:promotion_manager) }
    end

    initialize_with { new(promotion_manager) }

    trait :with_three_products do
      after(:build) do |catalogue, evaluator|
        catalogue.add('GREEN TEA', 'GR1', 3.11)
        catalogue.add('STRAWBERRIES', 'SR1', 5)
        catalogue.add('COFFEE', 'CF1', 11.23)
      end
    end

    trait :with_two_products do
      after(:build) do |catalogue, evaluator|
        catalogue.add('GREEN TEA', 'GR1', 3.11)
        catalogue.add('STRAWBERRIES', 'SR1', 5)
      end
    end

    trait :with_one_product do
      after(:build) do |catalogue, evaluator|
        catalogue.add('GREEN TEA', 'GR1', 3.11)
      end
    end

    trait :empty do
    end
  end
end
