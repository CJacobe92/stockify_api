require 'rails_helper'
require 'portfolio_updater'

RSpec.describe PortfolioUpdater do
  include PortfolioUpdater

  describe '#recalculate global values' do
    let(:stock) { create(:stock) }
    let(:sp) { create(:stock_price, stock: stock) }
    let(:account) { create(:account) }

    before do
      create(:buy, account: account, stock_id: sp.stock_id)
    end

    it 'calculates total_gl, percent_change, and total_value correctly' do

      existing_portfolio = account.portfolios.find_by(stock: stock)
      sp = StockPrice.find(existing_portfolio.stock_id)

      recalculate_global_values(existing_portfolio)

      expect(existing_portfolio.total_gl).to eq(0) 
      expect(existing_portfolio.percent_change).to eq(0) 
      expect(existing_portfolio.total_value).to eq(225.0)
    end
  end
end 