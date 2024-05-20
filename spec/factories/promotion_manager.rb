FactoryBot.define do
  factory :promotion_manager do
    initialize_with { new }

    trait :with_onexone_promotion do
      after(:build) do |promo_manager|
        promo_manager.instance_variable_set(:@active, { onexone: Set.new, bulk: {} })
        promo_manager.add_onexone('GR1')
      end
    end

    trait :with_bulk_promotion do
      after(:build) do |promo_manager|
        promo_manager.instance_variable_set(:@active, { onexone: Set.new, bulk: {} })
        conditions = { min_qty: 5, disc: 10 }
        promo_manager.add_bulk('CF1', conditions)
      end
    end

    trait :with_multiple_bulk_promotions do
      after(:build) do |promo_manager|
        promo_manager.instance_variable_set(:@active, { onexone: Set.new, bulk: {} })
        promo_manager.add_bulk('CF1', { min_qty: 3, disc: 33 })
        promo_manager.add_bulk('SR1', { min_qty: 5, disc: 10 })
      end
    end

    trait :empty do
      after(:build) do |promo_manager|
        promo_manager.instance_variable_set(:@active, { onexone: Set.new, bulk: {} })
      end
    end
  end
end
