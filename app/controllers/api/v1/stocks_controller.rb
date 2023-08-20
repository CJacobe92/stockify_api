require 'rest-client'

class Api::V1::StocksController < ApplicationController

  before_action :authenticate
  
  def index
    @stocks = Stock.includes(:stock_prices)
    render 'index', status: :ok
  end

  def update_current_prices
    api_endpoint = 'http://phisix-api2.appspot.com/stocks.json'
    response = RestClient.get(api_endpoint)
    data = JSON.parse(response.body)

    data['stock'].each do |stock_data|
      stock = Stock.find_or_initialize_by(symbol: stock_data['symbol'])
      stock.name = stock_data['name']
      stock.save
        
      stock_price = StockPrice.find_or_initialize_by(symbol: stock.symbol)
      stock_price.update(
        price: stock_data['price']['amount'],
      )
    end
  end

end
