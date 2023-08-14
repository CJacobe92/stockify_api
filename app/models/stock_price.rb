class StockPrice < ApplicationRecord
  belongs_to :stock

  attr_accessor :update_stock_volume

  def update_stock_volume(id, volume)
    stock = Stock.find(id)
    stock.update(volume: volume)
  end
end
