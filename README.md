# Cash Register - Ruby CLI

This is a developer guide based on the Technical Challenge outline.

## Functional Requirements

• Must add products to cart.
• Must compute price of cart.
• Must allow for promotions to be applied to modify the total price of cart, e.g.
    • Green Tea: buy 1, get 2 for the same price.
    • Strawberries: buy 3+, price drops from 5 to 4.50 per item.
    • Coffee: buy 3+ coffees, price drops to 2/3.
• Must recognize promotions applied regardless of the order the items were added in.
• Must allow the registration of new promotions to apply to cart cost.

## Technical Requirements

• Must follow TDD methodology.

## Other Requirements

• Readable
• Simple but usable
• Maintanable
• Extendable

## User Story

• Cash register can register a new product, register a new promotion or charge a customer (i.e. compute price of a cart).
  1. Register a new product
   • Cash register adds a new product to the shop.
  2. Register a new promotion
   • Cash register creates a new price rule involving one or more items.
  3. Charge a customer
    • Cash register takes 'scanned' product.
    • Cash register then adds product(s) to cart.
    • Cash register outputs current cart cost, including any promotions applied.
    • This repeats until there are no more products to scan and current (now final) cart cost is outputted.

## Domain Design

• `Product` has a name, a product code, and a price.
• `Shop` holds the products that have been registered in the shop (i.e. products eligible to be purchased).
• `Cart` holds a customer's selected products for purchase.
• `Promotion` holds information about promotions or pricing rules.
• `CashRegister` is the calculation engine: calculates the basket price before (subtotal) and after promotions (total).
• `Checkout` is a CLI: it takes scanned product input and keeps outputting current basket price.


