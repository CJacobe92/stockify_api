class Stock < ApplicationRecord
  has_many :portfolios
  has_many :stock_prices
  has_many :transactions
end
