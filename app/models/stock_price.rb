class StockPrice < ApplicationRecord
  belongs_to :stock

  validates :name, presence: true, on: :create
  validates :symbol, presence: true, on: :create
  validates :price, presence: true, on: :create
  validates :percent_change, presence: true, on: :create
  validates :volume, presence: true,  on: :create
  validates :currency, presence: true, on: :create

end
