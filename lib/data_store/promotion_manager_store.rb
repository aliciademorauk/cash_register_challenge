require 'pstore'

# Used to load and initialize test 'special conditions' on app start up and to persist the data when CLI.shutdown is executed

module PromotionManagerStore

  def load_seed_promotions
    store = PStore.new('promotions_data.pstore')
    promotions = { onexone: Set.new, bulk: {} }

    store.transaction(true) do
      promotions_data = store[:promotions] || { onexone: [], bulk: {} }
      promotions[:onexone] = Set.new(promotions_data[:onexone])
      promotions[:bulk] = promotions_data[:bulk]
    end

    promotions
  end

  def init_promotions_store
    store = PStore.new('promotions_data.pstore')
    store.transaction do
      store[:promotions] ||= {
        onexone: ['GR1'],
        bulk: {
          { min_qty: 3, disc: 33 } => ['CF1'],
          { min_qty: 5, disc: 10 } => ['SR1']
        }
      }
    end
  end

  def save_promotions(promotions)
    store = PStore.new('promotions_data.pstore')
    store.transaction do
      store[:promotions] = {
        onexone: promotions[:onexone].to_a,
        bulk: promotions[:bulk]
      }
    end
  end
end
