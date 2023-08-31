class Portfolio < ApplicationRecord
  belongs_to :account
  belongs_to :stock


  def self.create_portfolio(stock, account)
    existing_portfolio = self.find_by(stock: stock)
    sp = stock.stock_prices.find_by(stock: stock)

    if existing_portfolio.nil?
    portfolio = account.portfolios.create(
        symbol: sp&.symbol,
        description: sp&.name,
        current_price: 0,
        average_purchase_price: 0,
        total_quantity: 0,
        total_value: 0,
        percent_change: 0,
        total_gl: 0,
        total_cash_value: 0,
        stock: stock,
        account: account
      )
    end
  end

  def self.update_portfolio_for_buy(stock, account, quantity, total_cash_value)

    sp = stock.stock_prices.find_by(stock: stock)
    current_price = sp&.price

    existing_portfolio = self.find_by(stock: stock)
    
    total_quantity = existing_portfolio.total_quantity + quantity
    total_value = current_price * total_quantity
    total_cash_value =  existing_portfolio.total_cash_value + total_cash_value

    existing_portfolio.update(
      current_price: current_price,
      total_quantity: total_quantity,
      total_value: total_value,
      total_cash_value: total_cash_value
    )
    
    recalculate_global_values(existing_portfolio) if existing_portfolio.present?
  end
    
  def self.update_portfolio_for_sell(stock, account, quantity, total_cash_value)

    sp = stock.stock_prices.find_by(stock: stock)
    current_price = sp&.price

    existing_portfolio = self.find_by(stock: stock)
    total_quantity = existing_portfolio.total_quantity - quantity
    total_value =  current_price * total_quantity
    total_cash_value =  existing_portfolio.total_cash_value - total_cash_value

    if existing_portfolio.total_quantity < quantity
      raise StandardError, 'Quantity being sold is greater than owned assets.'
      return
    elsif total_quantity < 1
      account.update_account_balance_for_total_gl(account, existing_portfolio.total_gl)
      existing_portfolio.destroy
      
    else
      existing_portfolio.update(
        current_price: current_price,
        total_quantity: total_quantity,
        total_value: total_value,
        total_cash_value: total_cash_value
      )

      account.update_account_balance_for_total_gl(account, existing_portfolio.total_gl)
      recalculate_global_values(existing_portfolio) if existing_portfolio.present?
    end

  end

  private

  def self.recalculate_global_values(existing_portfolio)

  
      # Calculate total_gl and percent_change
      average_purchase_price = calculate_avg_purchase_price(existing_portfolio.total_cash_value, existing_portfolio.total_quantity)
      total_gl = calculate_total_gl(existing_portfolio.current_price, existing_portfolio.average_purchase_price, existing_portfolio.total_quantity)
      percent_change = calculate_percent_change(total_gl, existing_portfolio.total_value)

      # Update the calculated fields
      existing_portfolio.update(
        total_gl: total_gl, 
        percent_change: percent_change,
        average_purchase_price: average_purchase_price
      ) if existing_portfolio.present?
  end

  def self.calculate_avg_purchase_price(total_value, total_quantity)
    if total_quantity != 0
      average_purchase_price = total_value / total_quantity
    else
      average_purchase_price = 0
    end
  end

  def self.calculate_percent_change(total_gl, total_value)
    if total_gl !=0
      percent_change = ( total_gl / total_value) * 100
    else
      percent_change = 0
    end
  end

  def self.calculate_total_gl(current_price, average_purchase_price, total_quantity)
    if average_purchase_price !=0 && total_quantity !=0
      total_gl = (current_price - average_purchase_price) * total_quantity
    else
      total_gl = 0
    end
  end
end

