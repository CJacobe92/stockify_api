class Stock < ApplicationRecord
  has_many :portfolios
  has_many :stock_prices
  has_many :transactions

  validates :name, presence: true, on: :create
  validates :symbol, presence: true, on: :create
end
