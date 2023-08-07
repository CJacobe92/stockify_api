require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /create" do
    context 'with correct parameters' do

      before do
        @user = create(:user)
        valid_auth_params = {email: @user.email, password: @user.password}
        post '/api/v1/auth', params: {auth: valid_auth_params}
      end

      it 'returns a status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the "Login successful" message' do
        expect(json['message']).to eq('Login successful')
      end

      it 'returns uid header' do
        expect(response.headers['Uid']).to match(@user.id)
      end

      it 'returns authorization header' do
        expect(response.headers['Authorization']).to match(/^Bearer .+/)
      end

      it 'returns X-REQUEST-ID header' do
        expect(response.headers).to include('X-REQUEST-ID')
      end

      it 'returns a stockify client header' do
        expect(response.headers['client']).to include('stockify')
      end
    end
  end

  context 'with invalid auth params' do

    before do
      invalid_auth_params = {email: 'invalid_email@email.com', password: 'invalid_password'}
      post '/api/v1/auth', params: {auth: invalid_auth_params}
    end

    it "returns http status of 401" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "render 'Invalid login credentials' error" do
      expect(json['error']).to eq('Invalid login credentials')
    end
  end
end
