FactoryBot.define do
  factory :basket do
    initialize_with { new }

    trait :with_green_tea do
      after(:build) do |basket, evaluator|
        green_tea = build(:product, :green_tea)
        basket.add(green_tea.code, build(:catalogue, :with_three_products))
      end
    end

    trait :with_two_gt_and_two_cf do
      after(:build) do |basket, evaluator|
        catalogue = build(:catalogue, :with_three_products)
        green_tea = build(:product, :green_tea)
        coffee = build(:product, :coffee)
        2.times do
          basket.add(green_tea.code, catalogue)
          basket.add(coffee.code, catalogue)
        end
      end
    end

    trait :empty do
    end
  end
end

