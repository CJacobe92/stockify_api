require 'rails_helper'

RSpec.describe Account, type: :model do


  describe 'method /update_account_balance' do

    let(:stock) { create(:stock) }
    let(:sp) { create(:stock_price, stock: stock) }
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let(:transaction) {create(:buy, account: account, stock_id: sp.stock_id)}


    it 'update the account balance with correct value' do

      starting_balance = account.balance
      purchase_price = sp&.price
      total_cash_value = transaction.quantity * purchase_price
      ending_balance =  starting_balance - total_cash_value
      
      account.update_account_balance(account, ending_balance)

      expect(account.reload.balance).to eq(775)
    end
  end

  describe 'method /update_account_balance_for_total_gl' do

    let(:stock) { create(:stock) }
    let(:sp) { create(:stock_price, stock: stock) }
    let(:user) { create(:user) }
    let(:account) { create(:account, user: user) }
    let(:transaction) {create(:buy, account: account, stock_id: sp.stock_id)}
    let(:portfolio){ Portfolio.find_by(stock_id: sp.stock_id)}

    it 'update the account balance with correct value' do

      starting_balance = account.balance
      purchase_price = sp&.price
      total_cash_value = transaction.quantity * purchase_price
      ending_balance =  starting_balance - total_cash_value
      total_gl =  (portfolio.current_price - portfolio.average_purchase_price) * portfolio.total_value
      account.update_account_balance_for_total_gl(account, total_gl)

      expect(account.reload.balance).to eq(775)
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:portfolios).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:balance) }
  end

 
end 
