require 'tty-box'
require 'artii'

# Contains the app banner, product catalogue and receipt visuals

module Frames

  def self.banner
    a = Artii::Base.new :font => 'slant'
    a.asciify('Cash Register App')
  end

  def self.print_products(catalogue)
    content = <<~CATALOGUE
  
      #{catalogue}
  
      (Access active offers through Main Menu...)
    CATALOGUE

    box_height = content.lines.count + 4 
  
    box = TTY::Box.frame(
      title: { top_left: 'Today\'s products...' },
      width: 80,
      height: box_height,
      padding: 1,
      border: :thick,
    ) { content }

    puts "\n" * 2
    print box
    puts "\n" * 2
  end

  def self.receipt(items, subtotal, total)
    width = 80
    padding = 4
    dash_line = '-' * (width - padding)
    formatted_line = ->(label, value) { "#{label}#{value.to_s.rjust(width - label.length - padding)}" }
  
    data = <<~DATA
      #{dash_line}
      #{items}
      #{dash_line}
      #{formatted_line.call('SUBTOTAL:', subtotal)}
      #{formatted_line.call('TOTAL (WITH SAVINGS):', total)}
    DATA
  
    receipt_box = TTY::Box.frame(
      width: width,
      height: data.lines.count + 4, # Adjust height dynamically
      align: :left,
      padding: 1,
      border: :thick,
      title: { top_left: 'RECEIPT' },
      style: { bg: :white, fg: :black }
    ) { data }
  
    puts "\n" * 2
    print receipt_box
    puts "\n" * 2
  end  
  
end
