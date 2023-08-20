require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  
  describe 'POST /create' do
    context 'with correct authorization create transactions' do
      let(:stock) { create(:stock) }
      let(:sp) { create(:stock_price, stock: stock) }
      let!(:user){create(:user)}
      let!(:account){create(:account, user: user)}

      before do
        post "/api/v1/users/#{user.id}/accounts/#{account.id}/transactions", 
        params: { transaction: attributes_for(:buy) }.merge(stock_id: sp.stock_id), 
        headers: { 'Authorization' => header({ id: user.id, account: 'user' }) }

      end

      it 'returns status of 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with correct authorization create transactions' do
      let(:stock) { create(:stock) }
      let(:sp) { create(:stock_price, stock: stock) }
      let!(:user){create(:user)}
      let!(:account){create(:account, user: user)}

      before do
        post "/api/v1/users/#{user.id}/accounts/#{account.id}/transactions", 
        params: { transaction: attributes_for(:buy) }, 
        headers: { 'Authorization' => header({ id: user.id, account: 'user' }) }

      end

      it 'returns status of 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with an invalid account_id' do
      let(:user) { create(:user) }
      let(:invalid_account_id) { 999 } # An invalid account_id
  
      before do
        post "/api/v1/users/#{user.id}/accounts/#{invalid_account_id}/transactions", 
             params: { transaction: attributes_for(:buy) },
             headers: { 'Authorization' => header({ id: user.id, account: 'user' }) }
      end
  
      it 'returns status of 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end
  
      it 'returns an error message' do
        expect(json['error']).to eq('Account not found')
      end
    end
  end
end
