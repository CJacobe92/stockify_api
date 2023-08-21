require 'rails_helper'

RSpec.describe "Api::V1::Accounts", type: :request do
  
  describe 'PATCH /update' do
    let!(:user){create(:user)}
    let!(:account){create(:account, user: user)}
    
    before do
      patch "/api/v1/users/#{user.id}/accounts/#{account.id}", params: {account: { balance: "500"} }, headers: { 'Authorization' => header({id: user.id, account: 'user'}) }
      account.reload
    end

    it 'add a new balance on top of the current_balance' do
      expect(account.balance.to_s).to eq("1500.0")
    end
  end
end
