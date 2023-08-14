require 'rest-client'

class Api::V1::StocksController < ApplicationController
  def index
    @stocks = Stock.includes(:stock_prices)
    render 'index', status: :ok
  end
end
