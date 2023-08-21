class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :account

  before_create :create_or_update_user_account_portfolio

  validates :transaction_type, presence: true, on: :create
  validates :quantity, presence: true, on: :create

  def create_or_update_user_account_portfolio

    Portfolio.create_portfolio(stock, account)

    if transaction_type == 'buy'
      transaction_for_buy(stock, account, quantity)
    end
    
    if transaction_type == 'sell'
      transaction_for_sell(stock, account, quantity)
    end
    
  end

  private


  def transaction_for_buy(stock, account, quantity)

    sp = stock.stock_prices.find_by(stock: stock)

    purchase_price = sp&.price
    total_cash_value = quantity * purchase_price
    starting_balance =  account.balance
    
    if total_cash_value > starting_balance
      raise StandardError, 'Insufficient balance'
      return
    else
      Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)
      # update the transaction records
      self.price = purchase_price
      self.symbol = sp&.symbol
      self.total_cash_value = total_cash_value
  
      # update the account balance
      ending_balance = starting_balance - total_cash_value
      account.update_account_balance(account, ending_balance.round(2))
  
      # update the stock_prices volume
      volume = sp.volume - quantity
      sp.update(volume: volume)
    end
  end

  def transaction_for_sell(stock, account, quantity)
    sp = stock.stock_prices.find_by(stock: stock)

    sell_price = sp&.price
    total_cash_value = quantity * sell_price
    starting_balance =  account.balance

    Portfolio.update_portfolio_for_sell(stock, account, quantity, total_cash_value)
    # #update the transaction records
    self.price = sell_price
    self.symbol = sp&.symbol
    self.total_cash_value = total_cash_value

    # update the account balance
    ending_balance = starting_balance + total_cash_value
    account.update_account_balance(account, ending_balance.round(2))

    # update the stock_prices volumen
    volume = sp.volume + quantity
    sp.update(volume: volume)
  end

end
