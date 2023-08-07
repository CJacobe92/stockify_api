require 'rails_helper'

RSpec.describe "ApplicationController", type: :request do

  # user accessing the resources
  let!(:user){create(:user)}
  let!(:not_expired){(Time.now + 24.hours).iso8601()}

  describe 'correct authentication header' do
    context 'user controller requests' do

      # params for patch
      let(:user_params){FactoryBot.attributes_for(:user)}

      # user end points
      before do
        get '/api/v1/users', headers: { 'Authorization' => header(user_id: user.id)}
      end

      it "returns a 200 status" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  
  describe 'blank header' do
    before do
      get '/api/v1/users', headers: { 'Authorization' => ""}
    end

    it "returns 401 status" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns the correct error message" do
      expect(json['error']).to eq('Auth header missing')
    end
  end

  describe 'incorrect token' do
    
    before do
      @invalid_auth_header = header(user_id: user.id)
      @valid_auth_header = header(user_id: user.id)
      user.update(token: @valid_auth_header)

      get '/api/v1/users', headers: { 'Authorization' => "Bearer #{@invalid_auth_header}" }
    end
  
    it 'returns 401 status' do
      expect(response).to have_http_status(:unauthorized)
    end
  
    it 'returns the correct error message' do
      expect(json['error']).to eq('Invalid token')
    end
  end

  describe 'Authentication with expired token' do
    
    before do
      expiry = (Time.now - 48.hours).iso8601()
      payload = {user_id: user.id, expiry: expiry}
      @invalid_auth_header = JWT.encode(payload, Rails.application.credentials.secret_key_base)
      @sanitized_header = @invalid_auth_header.split(' ').last
      @decoded_token = decode_token(@sanitized_header)

      get '/api/v1/users', headers: { 'Authorization' => "Bearer #{@invalid_auth_header}"}
    end

    it 'returns 401 status' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns correct error message' do
      expect(json['error']).to eq('Token expired')
    end
  end

  describe 'Authentication with invalid token' do
    before do
      get '/api/v1/users', headers: { 'Authorization' => 'Bearer invalid_token' }
    end

    it 'returns 401 status' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns correct error message' do
      expect(json['error']).to eq('Not enough or too many segments')
    end
  end

end