require 'rails_helper'

RSpec.describe Transaction, type: :model do

  let(:stock) { create(:stock) }
  let(:sp) { create(:stock_price, stock: stock) }
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  context 'buy transaction' do

    it 'raises error when balance is insufficient' do
      
      account.update(balance: 0)

      expect {
        create(:buy, account: account, stock_id: sp.stock_id)
      }.to raise_error(StandardError, 'Insufficient balance')
    end

    it 'creates a new portfolio when none exists' do
      expect { create(:buy, account: account, stock_id: sp.stock_id) }.to change { Portfolio.count }.by(1)
    end

    it 'updates the portfolio correctly' do
      transaction = create(:buy, account: account, stock_id: sp.stock_id)
      portfolio = account.portfolios.find_by(stock: stock)

      expect(portfolio.total_quantity).to eq(500)
      expect(portfolio.total_value).to eq(transaction.total_cash_value)
    end
  end

  context 'sell transaction' do
    it 'updates the portfolio correctly' do
      create(:buy, account: account, stock_id: sp.stock_id)
      create(:sell, account: account, stock_id: sp.stock_id)
      portfolio = account.portfolios.find_by(stock: stock)

      expect(portfolio).to be_nil
    end
  end
 
  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:stock) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:transaction_type) }
    it { is_expected.to validate_presence_of(:quantity) }
  end
end
