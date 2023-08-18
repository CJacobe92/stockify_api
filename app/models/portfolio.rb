require 'pry'

class Portfolio < ApplicationRecord
  belongs_to :account
  belongs_to :stock

  def self.create_portfolio(account, stock, quantity, purchase_price)

    # variables
    sp = stock.stock_prices.find_by(stock: stock)

    sp = stock.stock_prices.find_by(stock: stock)
    transactions = Transaction.find_by(stock: stock)

    symbol = sp&.symbol
    description = sp&.name
    current_price = sp&.price
    average_purchase_price = purchase_price
    total_quantity = quantity
    total_value = (purchase_price * total_quantity)
    total_gl = (current_price - purchase_price) * quantity
    percent_change = (total_gl / total_value) * 100
  
    # initialize portfolio
    account.portfolios.create(
      symbol: symbol,
      description: description,
      current_price: current_price,
      average_purchase_price: average_purchase_price,
      total_quantity: total_quantity,
      total_value: total_value,
      percent_change: percent_change,
      total_gl: total_gl ,
      stock: stock,
      account: account,
    )
  end

  def update_portfolio(account, stock, quantity, existing_portfolio)

    sp = stock.stock_prices.find_by(stock: stock)

    transactions = account.transactions.where(stock_id: stock.id)
    current_price = sp&.price
    current_purchase = current_price * quantity

    total_purchase = existing_portfolio.total_value + current_purchase
    total_quantity = existing_portfolio.total_quantity + quantity

    average_purchase_price = total_purchase / total_quantity
    total_value = total_purchase
   
    total_gl = (current_price - average_purchase_price) * total_quantity
    percent_change = (total_gl / total_purchase) * 100

    existing_portfolio.update(
      current_price: current_price,
      average_purchase_price: average_purchase_price,
      total_quantity: total_quantity,
      total_value: total_value.round(2),
      percent_change: percent_change,
      total_gl: total_gl.round(2)   
    )
    puts "total_purchase #{total_purchase}"
    puts "current_p #{current_price}"
    puts "quantity: #{total_quantity}"
    puts "value: #{total_value.round(2)}"
    puts "avg_price #{average_purchase_price.rounded(2)}"
    puts "percent_change #{percent_change}"
    puts "total_gl #{total_gl.round(2)}"
  end
end
