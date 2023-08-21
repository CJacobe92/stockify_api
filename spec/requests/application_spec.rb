require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do
  # Global variables
  let!(:user){ create(:user) }
  let!(:admin){ create(:admin) }

  describe 'authenticate' do
    context 'with blank headers' do
      before do
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => nil }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      before do
        expiry = (Time.now - 48.hours).iso8601()
        user_payload = { id: user.id, expiry: expiry }
        admin_payload = { id: admin.id, expiry: expiry }

        user_headers = JWT.encode(user_payload, Rails.application.credentials.secret_key_base)
        admin_headers = JWT.encode(admin_payload, Rails.application.credentials.secret_key_base)

        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => "Bearer #{user_headers}" }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with verified user' do
      before do
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => header(id: user.id, account: 'user') }
      end

      it 'returns the current_user' do
        expect(assigns(:current_user)).to eq(user)
      end
    end

    context 'with verified admin' do
      before do
        token = encode_token(user_id: admin.id)
        get "/api/v1/admins/#{admin.id}", headers: { 'Authorization' => header(id: admin.id, account: 'admin') }
      end

      it 'returns the current_admin' do
        expect(assigns(:current_admin)).to eq(admin)
      end
    end

    

    context 'with invalid token' do
      before do
        invalid_token = "invalid_token"
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => "Bearer #{invalid_token}" }
      end

      it 'returns 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
