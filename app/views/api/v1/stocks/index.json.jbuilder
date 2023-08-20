json.data do
  json.array! @stocks do |stock|
    json.extract! stock, :id, :name, :symbol, :created_at, :updated_at
    json.stock_prices stock.stock_prices do |stock_price|
      json.extract! stock_price, :id, :price, :percent_change, :volume, :currency, :stock_id, :created_at, :updated_at
    end
  end
end
