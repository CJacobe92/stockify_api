class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :account

  before_create :create_or_update_user_account_portfolio

  validates :transaction_type, presence: true, on: :create
  validates :quantity, presence: true, on: :create

  def create_or_update_user_account_portfolio
    existing_portfolio = account.portfolios.find_by(stock: stock)

    if transaction_type == 'buy'
      if existing_portfolio.nil?
        portfolio = Portfolio.create_portfolio(stock, account)
        transaction_for_buy(stock, account, quantity)
      end
      
      transaction_for_buy(stock, account, quantity)
    end

    if transaction_type == 'sell'
      transaction_for_sell(stock, account, quantity)
    end
  end

  private

  def transaction_for_buy(stock, account, quantity)

    sp = stock.stock_prices.find_by(stock: stock)

    price = sp&.price
    symbol = sp&.symbol
    total_cash_value = (quantity * price)
    starting_balance =  account.balance
    
    if total_cash_value > starting_balance
      raise StandardError, 'Insufficient balance'
      return
    else
      Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)

      update_transaction_record(price, symbol, total_cash_value)
  
      ending_balance = starting_balance - total_cash_value
      account.update_account_balance(account, ending_balance.round(2))
      
      # stock volume
      volume = sp.volume - quantity
      sp.update(volume: volume)
    end
  end

  def transaction_for_sell(stock, account, quantity)
    sp = stock.stock_prices.find_by(stock: stock)

    price = sp&.price
    symbol = sp&.symbol
    total_cash_value = (quantity * price)
    starting_balance =  account.balance

    Portfolio.update_portfolio_for_sell(stock, account, quantity, total_cash_value)
    update_transaction_record(price, symbol, total_cash_value)

    ending_balance = starting_balance + total_cash_value
    account.update_account_balance(account, ending_balance.round(2))

    # stock volume
    volume = sp.volume + quantity
    sp.update(volume: volume)

  end

  def update_transaction_record(price, symbol, total_cash_value)
    self.price = price
    self.symbol = symbol
    self.total_cash_value = total_cash_value
  end

end
