require 'rest-client'

class Api::V1::StockPricesController < ApplicationController

  def snapshot
    api_endpoint = 'http://phisix-api2.appspot.com/stocks.json'
    response = RestClient.get(api_endpoint)
    data = JSON.parse(response.body)

    data['stock'].each do |stock_data|
      stock = Stock.find_or_initialize_by(symbol: stock_data['symbol'])
      stock.name = stock_data['name']
      stock.save
      
      stock_price = StockPrice.find_or_initialize_by(symbol: stock.symbol)
      stock_price.update(
        name: stock_data['name'],
        symbol: stock_data['symbol'],
        amount: stock_data['price']['amount'],
        percent_change: stock_data['percent_change'],
        currency: stock_data['price']['currency']
      )
    end
  end
end
