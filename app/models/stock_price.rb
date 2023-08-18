class StockPrice < ApplicationRecord
  belongs_to :stock

  validates :name, presence: true, on: :create
  validates :symbol, presence: true, on: :create
  validates :price, presence: true, on: :create
  validates :percent_change, presence: true, on: :create
  validates :volume, presence: true,  on: :create
  validates :currency, presence: true, on: :create
  
  def update_volume(stock, updated_volume)
    sp = StockPrice.find(stock.id)
    sp.update(volume: updated_volume)
  end

end
