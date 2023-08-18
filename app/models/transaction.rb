class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :account

  before_create :create_or_update_user_account_portfolio

  # validates :transaction_type, presence: true, on: :create
  # validates :quantity, presence: true, on: :create
  # validates :stock, presence: true, on: :create
  # validates :account, presence: true, on: :create

  def create_or_update_user_account_portfolio

    existing_portfolio = account.portfolios.find_by(stock: stock)

    if transaction_type == 'buy'
      if existing_portfolio.nil?
        create_transaction_account_portfolio(account, stock, quantity)
      else
        update_transaction_account_portfolio(account, stock, quantity, existing_portfolio)
      end
    end

    if transaction_type == 'sell'
      update_transaction_account_portfolio_for_sell(account, stock, shares, existing_portfolio) unless existing_portfolio.nil?
    end

  end

  private

  def create_transaction_account_portfolio(account, stock, quantity)
    sp = stock.stock_prices.find_by(stock: stock)

    purchase_price = sp&.price
    total_purchase = quantity * purchase_price
    starting_balance =  account.balance

    if total_purchase > starting_balance
      raise StandardError, 'Insufficient balance'
      return
    else
      Portfolio.create_portfolio(account, stock, quantity, purchase_price)

      # update the transaction records
      self.price = purchase_price
      self.symbol = sp&.symbol
      self.total_purchase = total_purchase

      # update the account balance
      ending_balance = starting_balance - total_purchase
      account.update_account_balance(account, ending_balance)

      # update the stock_prices volumen
      volume = sp.volume - quantity
      sp.update(volume: volume)
    end
  end

  def update_transaction_account_portfolio(account, stock, quantity, existing_portfolio)

    sp = stock.stock_prices.find_by(stock: stock)

    purchase_price = sp&.price
    total_purchase = quantity * purchase_price
    starting_balance =  account.balance

    if total_purchase > starting_balance
      raise StandardError, 'Insufficient balance'
      return
    else
      account.portfolios.find(existing_portfolio.id).update_portfolio(account, stock, quantity, existing_portfolio)

      # #update the transaction records
      self.price = purchase_price
      self.symbol = sp&.symbol
      self.total_purchase = total_purchase

      # update the account balance
      ending_balance = starting_balance - total_purchase
      account.update_account_balance(account, ending_balance)

      # update the stock_prices volumen
      volume = sp.volume - quantity
      sp.update(volume: volume)
    end
  end

end
