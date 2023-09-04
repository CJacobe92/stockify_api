require 'rails_helper'

RSpec.describe Portfolio, type: :model do

  let(:stock) { create(:stock) }
  let(:sp) { create(:stock_price, stock: stock) }
  let(:account) { create(:account) }

  describe '.create_portfolio' do

    it 'create new portfolio if there are no existing' do
      existing_portfolio = Portfolio.find_by(stock_id: sp.stock_id)

      expect {
        Portfolio.create_portfolio(stock, account)
      }.to change(Portfolio, :count).by(1)
    end
  end

  describe '.update_porfolio_for_buy' do
  
    context 'updates the necessary columns when the buy method is called' do
      let(:existing_portfolio){Portfolio.find_by(stock_id: sp.stock_id)}
      let(:quantity){500}
      let(:total_cash_value){quantity * sp&.price}

      before do
        Portfolio.create_portfolio(stock, account)
        Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)
      end

      it 'updates the current_price with the correct value' do
        current_price =  sp&.price
        expect(existing_portfolio.current_price).to eq(current_price)
      end

      it 'updates the total_quantity with the correct value' do
        expect(existing_portfolio.total_quantity).to eq(500)
      end

      it 'updates the total_value with the correct value' do
        expect(existing_portfolio.total_value).to eq(total_cash_value)
      end
    end
  end

  describe '.update_portfolio_for_sell error handling' do
    let(:quantity) { 500 }
    let(:total_cash_value) { quantity * sp&.price }
  
    it 'raises an error when selling on an empty portfolio' do
      expect {
        Portfolio.update_portfolio_for_sell(stock, account, quantity, total_cash_value)
      }.to raise_error(StandardError, 'Cannot sell unowned assets.')
    end

    it 'raises an error when selling greater than owned assets' do
      Portfolio.create_portfolio(stock, account)
      Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)

      wrong_quantity = 10000

      expect {
        Portfolio.update_portfolio_for_sell(stock, account, wrong_quantity, total_cash_value)
      }.to raise_error(StandardError, 'Quantity being sold is greater than owned assets.')
    end

    it 'destroys the portfolio when there are no longer owned assets' do

      quantity_being_sold = 500

      Portfolio.create_portfolio(stock, account)
      Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)
      Portfolio.update_portfolio_for_sell(stock, account, quantity_being_sold, total_cash_value)

      expect(Portfolio.count).to eq(0)
    end
  end
  
  describe '.update_portfolio_for_sell' do
      let(:existing_portfolio){Portfolio.find_by(stock_id: sp.stock_id)}
      let(:quantity){1000}
      let(:quantity_to_sell){500}
      let(:total_cash_value){quantity * sp&.price}

      before do
        Portfolio.create_portfolio(stock, account)
        Portfolio.update_portfolio_for_buy(stock, account, quantity, total_cash_value)
        Portfolio.update_portfolio_for_sell(stock, account, quantity_to_sell, total_cash_value)
      end

      it 'updates the current_price with the correct value' do
        current_price =  sp&.price
        expect(existing_portfolio.current_price).to eq(current_price)
      end

      it 'updates the total_quantity with the correct value' do
        expect(existing_portfolio.total_quantity).to eq(500)
      end

      it 'updates the total_value with the correct value' do
        expect(existing_portfolio.total_value).to eq(225.0)
      end
  end
 
  describe 'associations' do
    it { is_expected.to belong_to(:stock) }
    it { is_expected.to belong_to(:account) }
  end
end
