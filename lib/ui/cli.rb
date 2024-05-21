require 'tty-prompt'
require_relative 'frames'
require_relative '../basket'
require_relative '../catalogue'
require_relative '../product'
require_relative '../promotion_manager'
require_relative '../data_store/catalogue_store'
require_relative '../data_store/promotion_manager_store'
require_relative '../services/input_validation'

class CLI
  extend InputValidation
  extend CatalogueStore
  extend PromotionManagerStore 

  def self.start_cash_register
    @promotion_manager = PromotionManager.new
    @catalogue = Catalogue.new(@promotion_manager)
    @prompt = TTY::Prompt.new(active_color: :blue, interrupt: :exit)
    self.greet
  end

  def self.greet
    set_ui
    main_menu
  end

  def self.main_menu
    show_menu('MAIN MENU', {
      'Go To Checkout' => -> { set_ui; checkout },
      'Manage Products/Promotions' => -> { set_ui; config },
      'Exit' => -> { shutdown }
    })
  end

  def self.config
    show_menu('', {
      'Manage Products' => -> { to_products },
      'Manage Promotions' => -> { to_promotions },
      'Main Menu' => -> { main_menu },
      'Exit' => -> { shutdown }
    })
  end

  def self.to_products
    show_menu('', {
      'Add/Delete Products' => -> { manage_products; main_menu },
      'Main Menu' => -> { main_menu }
    })
  end

  def self.to_promotions
    show_menu('', {
      'See Active Promotions'=> -> { print_promotions; main_menu },
      'Add/Delete Promotions' => -> { manage_promotions; main_menu },
      'Main Menu' => -> { main_menu }
    })
  end

  def self.checkout
    basket = Basket.new
    subtotal = scan_products(basket)
    process_checkout(basket, subtotal)
    return main_menu
  end

  def self.manage_products
    option = show_add_del
    case option
    when :add
      add_product
    when :del
      delete_product
    end
    return to_products
  end

  def self.manage_promotions
    option = show_add_del
    product = find_product_for_promos
  
    unless product.nil?
      case option
      when :add
        add_promotion(product)
      when :del
        delete_promotion(product)
      end
    end
    return to_promotions
  end

  private

  # Save data and exit

  def self.shutdown
    save_catalogue(@catalogue.products)
    save_promotions(@promotion_manager.active)
    exit 0
  end

  # Display/UI private methods

  def self.set_ui
    system 'clear'
    puts Frames.banner
    Frames.print_products(@catalogue.list)
    puts '>>>>>>'
  end

  def self.print_promotions
    puts <<~PROMOS

      Today's promotions...
      
      #{@promotion_manager.list}

    PROMOS
  end

  def self.show_menu(title, choices)
    @prompt.select(title, quiet: true) do |menu|
      choices.each { |choice_name, action| menu.choice(choice_name, action) }
    end
  end

  def self.show_add_del()
    @prompt.select('') do |menu|
      menu.choice name: 'Add', value: :add
      menu.choice name: 'Delete', value: :del
      menu.choice name: 'Main Menu', value: -> { main_menu }
    end
  end

  ### Promo/product input validation private methods  ###

  # Note that we choose not to rely on tty:prompt's validation features because classes that can be instantiated with user 
  # input should have their validation rules defined within them (see Product and Promotion Manager)

  def self.get_validated_product_attr(attr_name)
    attr = get_string_attr("Enter #{attr_name.upcase}:")
    until validated?(attr_name.to_sym, attr, Product::INPUT_VAL_RULES)
      attr = get_string_attr("Invalid format. #{attr_name.upcase}:")
    end
    attr
  end

  def self.get_validated_promo_attr(key, attr_name)
    attr = get_number_attr("Enter #{attr_name.upcase}:")
    until validated?(key.to_sym, attr, PromotionManager::INPUT_VAL_RULES)
      attr = get_number_attr("Invalid format. #{attr_name.upcase}:")
    end
    attr
  end

  def self.get_string_attr(message)
    @prompt.ask(message) { |q| q.required true; q.modify :strip, :up }
  end

  def self.get_number_attr(message)
    @prompt.ask(message) { |q| q.required true; q.modify :strip; q.convert :integer}
  end

  ### Find product with valid code ###

  def self.find_product
    @catalogue.find(get_string_attr('Enter product CODE:'))
  end

  ### MANAGE PRODUCTS ###

  def self.add_product
    code = get_validated_product_attr('code')
    product = find_product
  
    if product.nil?
      name = get_validated_product_attr('name')
      price = get_validated_product_attr('price')
      confirm_message = "Confirm?: #{name} [#{code}]: #{price}"
      
      if @prompt.yes?(confirm_message)
        @catalogue.add(name, code, price)
        @prompt.ok('Product successfully added!')
      else
        @prompt.warn('Aborted...')
      end
    else 
      @prompt.warn('Product already exists.')
    end
  end
  
  def self.delete_product
    code = get_string_attr('Enter CODE:')
    if @catalogue.find(code)
      @catalogue.delete(code)
      @prompt.ok('Product successfully removed!')
    else
      @prompt.warn('Product does not exist.')
    end
  end

  ### MANAGE PROMOTIONS ###

  def self.find_product_for_promos
    product = find_product
    if product.nil?
      @prompt.warn('Product does not exist.')
    end
    product
  end

  def self.find_promotion(product)
    @promotion_manager.find(product.code) ? @prompt.warn('The product already has a promotion.') : nil
  end
  
  def self.add_promotion(product)
    return unless find_promotion(product).nil?
  
    type = select_promotion
    case type
    when :onexone
      add_onexone_promotion(product)
    when :bulk
      add_bulk_promotion(product)
    end
  end
  
  def self.select_promotion
    @prompt.select('Select type:') do |menu|
      menu.choice name: 'One For One', value: :onexone
      menu.choice name: 'Bulk Buy', value: :bulk
    end
  end
  
  def self.add_onexone_promotion(product)
    message = "Confirm?: Buy #{product.name} [#{product.code}] Get One Free"
    if @prompt.yes?(message)
      @promotion_manager.add_onexone(product.code)
      @prompt.ok('Promotion successfully added!')
    else
      @prompt.warn('No action was taken.')
    end
  end
  
  def self.add_bulk_promotion(product)
    disc = get_validated_promo_attr('disc', 'discount')
    min_qty = get_validated_promo_attr('min_q', 'min. quantity')
    message = "Confirm?: #{product.name} [#{product.code}]: Buy #{min_qty} Get #{disc}% Off."
    if @prompt.yes?(message)
      @promotion_manager.add_bulk(product.code, { min_qty: min_qty, disc: disc })
      @prompt.ok('Promotion successfully added.')
    else
      @prompt.say('No action was taken.')
    end
  end
  
  def self.delete_promotion(product)
    if @promotion_manager.delete(product.code)
      @prompt.ok('Promotion successfully removed!')
    else
      @prompt.warn('This promotion is not active. No action was taken.')
    end
  end

  ### CHECKOUT ###

  def self.scan_products(basket)
    @prompt.say('Enter product codes, press [=] when basket is full:')
    code = get_string_attr('SCAN >')
    until code == '='
      if basket.add(code, @catalogue).nil?
        @prompt.warn('No product found in catalogue. Try again:')
      else
        subtotal = basket.get_subtotal
        @prompt.ok("Current total: #{subtotal}")
      end
      code = get_string_attr('SCAN >')
    end
    subtotal ||= basket.get_subtotal
  end

  def self.process_checkout(basket, subtotal)
    if subtotal.to_f.zero? 
      @prompt.warn("\nNothing was added to the basket.\n")
    else 
      @prompt.say(finish_checkout(basket.list, subtotal, basket.get_total(@promotion_manager)))
    end
  end

  def self.finish_checkout(basket, subtotal, total)
    Frames.receipt(basket, subtotal, total)
  end

end