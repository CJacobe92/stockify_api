require 'rails_helper'
require 'portfolio_updater'

RSpec.describe PortfolioUpdater do
  include PortfolioUpdater

  describe '#recalculate global values' do
    let(:stock) { create(:stock) }
    let(:sp) { create(:stock_price, stock: stock) }
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }

    it 'calculates total_gl, percent_change, and total_value correctly' do
      create(:buy, account: account, stock_id: sp.stock_id)

      existing_portfolio = account.portfolios.find_by(stock: stock)

      recalculate_global_values(existing_portfolio)

      expect(existing_portfolio.total_gl).to eq(0) 
      expect(existing_portfolio.percent_change).to eq(0) 
      expect(existing_portfolio.total_value).to eq(225.0)
    end

    describe '#calculate_avg_purchase_price' do
      it 'calculates average purchase price correctly' do
        total_value = 1000.0
        total_quantity = 10

        average_purchase_price = calculate_avg_purchase_price(total_value, total_quantity)

        expect(average_purchase_price).to eq(100.0) # 1000 / 10 = 100.0
      end

      it 'returns 0 when total_quantity is 0' do
        total_value = 0.0
        total_quantity = 0

        average_purchase_price = calculate_avg_purchase_price(total_value, total_quantity)

        expect(average_purchase_price).to eq(0)
      end
    end

    describe '#calculate_percent_change' do
      it 'calculates percent change correctly' do
        total_gl = 50.0
        total_value = 500.0

        percent_change = calculate_percent_change(total_gl, total_value)

        expect(percent_change).to eq(10.0) # (50 / 500) * 100 = 10.0
      end

      it 'returns 0 when total_gl is 0' do
        total_gl = 0.0
        total_value = 500.0

        percent_change = calculate_percent_change(total_gl, total_value)

        expect(percent_change).to eq(0)
      end
    end

    describe '#calculate_total_gl' do
      it 'calculates total_gl correctly' do
        current_price = 10.0
        average_purchase_price = 5.0
        total_quantity = 20

        total_gl = calculate_total_gl(current_price, average_purchase_price, total_quantity)

        expect(total_gl).to eq(100.0) # (10 - 5) * 20 = 100.0
      end

      it 'returns 0 when average_purchase_price is 0' do
        current_price = 10.0
        average_purchase_price = 0
        total_quantity = 20

        total_gl = calculate_total_gl(current_price, average_purchase_price, total_quantity)

        expect(total_gl).to eq(0)
      end
    end
  end
end 