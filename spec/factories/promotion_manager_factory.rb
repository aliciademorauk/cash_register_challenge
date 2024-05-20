FactoryBot.define do
  factory :promotion_manager do
    initialize_with { new }

    trait :with_onexone_promotion do
      after(:build) do |promo_manager|
        promo_manager.add_onexone('GR1')
      end
    end

    trait :with_bulk_promotion do
      after(:build) do |promo_manager|
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk('CF1', conditions)
      end
    end

    trait :empty do
      # This will create an empty PromotionManager
    end
  end
end
