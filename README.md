<div align="center">

<br />

  <h1 align="center">Cash Register CLI Application</h1>
  
  <p align="center">
    <p> · Cash register tool simulation built in vanilla Ruby · </p>
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

* **General Interpretation**: I have attempted to simulate a cash register tool in a physical store, given the mention of products being scanned. It has three primary functionalities: 
    * managing promotions, 
    * managing products,
    * checking out (filling up a basket and calculating total). 

* **Scope**: The cash register is not responsible for handling payments; it's duty ends when it correctly computes a basket price with promotions. The cash register is not aware of the stock levels in the shop, only of the product details (name, code, price) of the items available.

* **User**: The user of the tool is the shop owner or worker. They have the option to 'scan' products (by entering valid product codes) and 'checkout', as well as configure prices and promotions by selecting the appropriate menu options.

## Promotions Logic

* To offer the shop owner flexibility with a straightforward approach, promotions are applied to unique product codes, and they have been divided in two key types: Buy One Get One and Bulk Buy.
  
    * **Bulk Buy**:
        * Configured through the CLI, the operator can set a minimum quantity to be added to basket and a discount to be applied for a specific code.
        * All products with the same code that are in the basket at the time of checkout after the promotion is added will be discounted by the specified discount if the minimum quantity is met.
        * This promotion type is stored as follows: in a hash where the key is the conditions `{:min_q, :disc}` and the value is a list of product codes that should be discounted with those conditions.
        * This ensures that codes with the same Bulk Buy promotion conditions are appended to a list, avoiding repetition. The following promotions fall under this category:
            * Coffee: buy 3+ coffees, price drops to 2/3.
                * <em> Note that, for simplicity, this specific discount has been specified as a 33% discount. However, it can be flexibly added and removed through the CLI.</em>
            * Strawberries: buy 3+, price drops from 5 to 4.50 per item.
          
    * **Buy One Get One**:
        * Configured through the CLI, this promotion does not take any conditions or inputs, other than the product code.
        * For every pair of the same code in the basket, 1 x price is discounted from the basket.
        * This implies that for odd numbers, the total discount for each code will always be less than half.  The following promotions fall under this category:
            * Green Tea: buy 1, get 2 for the same price.

## User Story

* Cash register can register a new product, register a new promotion or charge a customer (i.e. compute price of a cart).
  * Register a new product
      * Cash register adds a new product to the shop.
  * Register a new promotion
       * Cash register leverages promotion logic involving a specific item.
  * Charge a customer
        * Cash register takes 'scanned' product.
        * Cash register then adds product(s) to cart.
        * Cash register outputs current cart cost, including any promotions applied.
        * This repeats until there are no more products to scan (i.e. user presses = key) and current (now final) cart cost is outputted.

## Domain Design

* `Product` has a name, a product code, and a price stored in cents. Products are uniquely identified through their code.
* `Catalogue` manages the products that have been registered (i.e. products eligible to be added to basked and purchased).
* `Basket` manages a basket session; it keeps track of the items in the basket, the subtotal, the total (subtotal - basket savings).
* `PromotionManager` holds information about pricing rules and their application, as well as the codes they are matched to.
* `CLI` is in charge of I/O, and with that, input validation. It is in charge of translating the users choices and inputs into actions. It instantiates the necessary classes and loads the initial data; it displays menus; it uses services (Modules) to perform input validation.

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
    
  * Run `ruby bin/run.rb`.
