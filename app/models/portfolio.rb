class Portfolio < ApplicationRecord
  belongs_to :account
  belongs_to :stock

  # attr_accessor :calculate_unrealized_pl

  # def update_portfolio(amount, shares, stock_id)
  #   update(amount: amount, shares: shares, stock_id: stock_id)
  # end

  # def current_stock_price
  #   latest_stock_price = stock.stock_prices.prices(updated_at: :desc).first
  #   return latest_stock_price&.amount
  # end

  # def calculate_unrealized_pl
  #   if stock && account
  #     self.unrealized_pl = (current_stock_price - purchase_price) * shares
  #   else
  #     nil
  #   end
  # end
end
