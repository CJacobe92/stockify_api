require 'rails_helper'

RSpec.describe Transaction, type: :model do
 
  describe 'create_or_update_user_account_portfolio' do

    context 'first buy transaction' do

      let!(:stock){ create(:stock) } 
      let!(:sp){ create(:stock_price, stock: stock)}
    
      let!(:user){ create(:user) }
      let!(:account){ create(:account, user: user) } 
      let!(:transaction){ create(:buy, account: account, stock_id: sp.stock_id) }
      let!(:portfolio){account.portfolios.find_by(stock_id: stock.id)}
      let!(:unrealized_pl){ sp&.amount * transaction.shares}

      before do
        portfolio.reload
        account.reload
      end

      it 'creates a new portfolio when none exists' do
        expect(portfolio).not_to be_nil
      end

      it 'update new portfolio with correct shares values' do
        expect(portfolio.shares.to_s).to eq("500")
      end

      it 'updates new portfolio with correct purchase_price' do
        expect(portfolio.purchase_price.to_s).to eq("0.455")
      end

      it 'updates new portfolio with correct unrealized_pl' do
        expect(portfolio.unrealized_pl.to_s).to eq("227.5")
      end

      it 'updates new portfolio with correct equity' do
        expect(portfolio.equity.to_s).to eq("1227.5")
      end

      it 'update the account_balance' do
        expect(account.balance.to_s).to eq("772.5")
      end
    end

    context 'on_going buy transactions' do

      # initiate the portfolio
      let!(:stock){ create(:stock) } 
      let!(:sp){ create(:stock_price, stock: stock)}
    
      let!(:user){ create(:user) }
      let!(:account){ create(:account, user: user) } 
      let!(:transaction){ create(:buy, account: account, stock_id: sp.stock_id) }
      let!(:next_transaction){ create(:buy, account: account, stock_id: sp.stock_id) }
      let!(:portfolio){account.portfolios.find_by(stock_id: stock.id)}
      let!(:unrealized_pl){ sp&.amount * transaction.shares}

      # 

      it 'checks if an existing portfolio exists' do
        existing_portfolio = account.portfolios.find_by(stock_id: stock.id)
        expect(existing_portfolio).not_to be_nil
      end

      it 'update the existing portfolio with correct shares values' do

        expect(portfolio.shares).to eq(1000)
      end

      it 'updates new portfolio with correct purchase_price' do
        expect(portfolio.purchase_price).to eq(0.455)
      end

      it 'updates new portfolio with correct unrealized_pl' do
        expect(portfolio.unrealized_pl).to eq()
      end

      # it 'updates new portfolio with correct equity' do
      #   account = attributes_for(:account)
      #   equity = account[:balance].to_f + unrealized_pl
      #   expect(portfolio.equity).to eq(equity)
      # end

    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to belong_to(:stock) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:transaction_type) }
    it { is_expected.to validate_presence_of(:shares) }
  end


end
