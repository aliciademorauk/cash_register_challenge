<div align="center">

<br />

  <h1 align="center"> :money_with_wings: Cash Register CLI App :money_with_wings: </h1>
  
  <p align="center">
    <p> · Cash register app simulation built in Ruby · </p>
  </p>
  
</div>

<br />

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#summary">Requirements Interpretation</a>
    </li>
    <li>
      <a href="#promotions-logic">Promotions Logic</a>
    </li>
    <li>
      <a href="#user-story">User Story</a>
    </li>
    <li>
      <a href="#domain-design">Domain Design</a>
    </li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#running-the-app">Running The App</a></li>
      </ul>
  </ol>
</details>

## Requirements Interpretation

* **General Interpretation**: This program simulates a cash register tool in a physical store, given the mention of products being scanned, amongst other things. It has three primary features for the user: 
    * managing promotions, 
    * managing products,
    * checking out (filling up a basket and calculating total). 

* **Scope**: The cash register is not responsible for handling payments; it's duty ends when it correctly computes a basket price with promotions. The cash register is not aware of the stock levels in the shop, only of the product details (name, code, price) of the items available.

* **User**: The user of the tool is the shop owner or worker. They have the option to 'scan' products (enter valid product codes on the command line) and 'checkout', as well as configure prices and promotions by selecting the appropriate menu options.

## Promotions Logic

* To offer the shop owner flexibility with a straightforward approach, promotions are applied to unique product codes, and every product code can only have one promotion. Promotions have been divided into two key types: Buy One Get One and Bulk Buy.
  
    * **Bulk Buy**:
        * Configured through the CLI, the operator can set a minimum quantity and a given discount to be applied to all units of an item in a basket.
        * All products with the same code that are in the basket after the promotion is correctly added will be discounted by the specified percentage if the minimum quantity is met.
        * The data for this promotion type is stored with the key being the conditions `{:min_q, :disc}` and the value a list of product codes that should be discounted with those conditions. This ensures that codes with the same Bulk Buy promotion conditions are appended to a list rather than generating another key-value pair in the hash. From the "special conditions" given in the challenge instructions, the following fall under this category:
            * Coffee: buy 3+ coffees, price drops to 2/3.
                * <em> This specific discount has been denoted as 33% discount.</em>
            * Strawberries: buy 3+, price drops from 5 to 4.50 per item.
          
    * **Buy One Get One**:
        * Configured through the CLI, this promotion does not take any conditions or inputs, other than the product code.
        * For every pair of items with the same code in the basket, 1 x price is discounted from the basket.
        * For an odd quantity, the total discount will always be less than half (e.g. 9 of the same item in your basket generate a discount of 4 x price). The following promotions fall under this category:
            * Green Tea: buy 1, get 2 for the same price.

## User Story

* Cash register can register a new product, register a new promotion or checkout a customer's items (i.e. compute price of a basket).
  * Register a new product:
      * Cash register adds a new product to the shop.
  * Register a new promotion:
       * Cash register leverages promotion logic involving a specific item.
  * Charge a customer:
        * Cash register takes 'scanned' products in order.
        * For every addition to cart, cash register outputs current cart cost, including any promotions applied.
        * This repeats until there are no more products to scan (i.e. user presses = key) and final cart cost is outputted, including savings.

## Domain Design

* `Product` has a name, a product code, and a price stored in cents. Products are uniquely identified through their code, which must follow a specific format alongside the other attributes of the class instances.
* `Catalogue` manages the products that have been registered (i.e. products eligible to be added to basked and purchased), ensuring deleting a specific product delets its unique code from the active promotions store.
* `Basket` manages a basket session; it keeps track of the items in the basket, the subtotal, the total (subtotal - basket savings).
* `PromotionManager` manages pricing rules and their application to basket, as well as the codes they are matched to.
* `CLI` is in charge of I/O, and with that, input validation. It is in charge of translating the users' choices into scripts. It instantiates the necessary classes and loads the initial data; it displays menus; it uses services (modules) to perform input validation.

## Getting Started

### Prerequisites

* Must have Ruby installed, check with `ruby -v` on the command line. Otherwise, install it [here](https://www.ruby-lang.org/en/documentation/installation/).


### Installation

  * Clone this repository: `git clone https://github.com/aliciademorauk/cash_register_challenge`.

  * Navigate to the repository: `cd cash_register_challenge`.
    
  * Run `bundle install` to install all the gems in the Gemfile, scoped to this project.
      * Testing:
          * gem 'rspec'
          * gem 'factory_bot'
      * Data Store:
          * gem 'pstore'
      * User Interface:
          * gem 'tty-prompt'
          * gem 'tty-box'
          * gem 'artii'
    

### Running the App
    
  * Run app through run.rb entry point with `ruby bin/run.rb`.
  * Run tests with RSpec:
    * `bundle exec rspec` for all tests.
    * `bundle exec rspec path/to/test_file_spec.rb` for specific test file.
