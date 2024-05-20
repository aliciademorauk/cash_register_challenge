require 'pstore'

# Used to load and initialize test products into catalogue on app start up and to save products to tempfile when CLI.shutdown is executed

module CatalogueStore

  def load_seed_catalogue
    store = PStore.new('catalogue_data.pstore')
    products = {}
    store.transaction(true) do
      catalogue_data = store[:catalogue] || []
      catalogue_data.each do |entry|
        product = Product.new(
          name: entry[:name],
          code: entry[:code],
          price: BigDecimal(entry[:price]) / 100
        )
        products[entry[:code]] = product
      end
    end
    products
  end

  def init_catalogue_store
    store = PStore.new('catalogue_data.pstore')
    store.transaction do
      store[:catalogue] ||= [
        { name: 'GREEN TEA', code: 'GR1', price: 311 },
        { name: 'STRAWBERRIES', code: 'SR1', price: 500 },
        { name: 'COFFEE', code: 'CF1', price: 1123 }
      ]
    end
  end

  def save_catalogue(products)
    store = PStore.new('catalogue_data.pstore')
    store.transaction do
      store[:catalogue] = products.map do |code, product|
        { name: product.name, code: product.code, price: product.price_in_cents }  
      end
    end
  end
end
