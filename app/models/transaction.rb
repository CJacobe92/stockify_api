class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :account

  after_create :create_or_update_user_account_portfolio

  # formulas for reference:




  def create_or_update_user_account_portfolio

    if transaction_type == 'buy'

      # formula

      # unrealized_pl =  shares * price_at_purchase
      # equity = account.balance + unrealized_pl

      # variables
      sp = StockPrice.where(stock_id: stock.id).order(updated_at: :desc).first
      stockprice_at_purchase = sp.amount
      unrealized_pl = sp.amount * shares
      remaining_balance = account.balance - unrealized_pl

      existing_portfolio = account.portfolios.find_by(stock: stock)

      if existing_portfolio
        update_existing_portfolio(
          existing_portfolio,
          sp,
          stockprice_at_purchase,
          unrealized_pl,
          remaining_balance
        )
      else
        create_new_portfolio(
          sp,
          stockprice_at_purchase, 
          unrealized_pl, 
          remaining_balance
        )
      end
    elsif transaction_type == 'sell'

      # formula
      # sold_unrealized_pl = existing_shares * stockprice_at_sale
      # unrealized_pl =  existing_unrealized_pl - (sold_unrealized_pl)
      # equity = account.balance + sold_unrealized_pl

      sp = StockPrice.where(stock_id: stock.id).order(updated_at: :desc).first
      stockprice_at_sale = sp.amount
      remaining_balance = account.balance + (stockprice_at_sale * shares)

      existing_portfolio = account.portfolios.find_by(stock: stock)

      if existing_portfolio
        update_existing_portfolio_for_sell(existing_portfolio, sp, stockprice_at_sale, remaining_balance)
      end
    end
  end
  
  private

  def update_existing_portfolio(existing_portfolio, sp, stockprice_at_purchase, unrealized_pl, remaining_balance)

    current_unrealized_pl = existing_portfolio.unrealized_pl + unrealized_pl

    existing_portfolio.update(
      shares: existing_portfolio.shares + shares,
      purchase_price: stockprice_at_purchase,
      unrealized_pl: current_unrealized_pl,
      equity: account.balance + current_unrealized_pl
    )

    update_required_tables(remaining_balance, sp)

  end

  def create_new_portfolio(sp, stockprice_at_purchase, unrealized_pl, remaining_balance)

    new_portfolio = account.portfolios.create(
      stock: stock,
      shares: shares,
      purchase_price: stockprice_at_purchase,
      unrealized_pl: unrealized_pl,
      equity: account.balance + unrealized_pl
    )

    update_required_tables(remaining_balance, sp)

  end

  def update_existing_portfolio_for_sell(existing_portfolio, sp, stockprice_at_sale, remaining_balance)
    sold_unrealized_pl = existing_portfolio.shares * stockprice_at_sale
    remaining_unrealized_pl = existing_portfolio.unrealized_pl - sold_unrealized_pl

    existing_portfolio.update(
      shares: existing_portfolio.shares - shares,
      unrealized_pl: remaining_unrealized_pl,
      equity: account.balance + sold_unrealized_pl 
    )

    if existing_portfolio.shares < 1
      existing_portfolio.destroy
    end

    update_required_tables(remaining_balance, sp)
  end


  def update_required_tables(remaining_balance, sp)

    # update the account balance after purchasing
    account.balance = remaining_balance
    self.balance = account.balance
    account.save
    
    # update the stock volumes after purchasing
    sp.volume = sp.volume - shares
    sp.save

    # update the transaction amount column
    self.amount = sp.amount * shares

  end
end
