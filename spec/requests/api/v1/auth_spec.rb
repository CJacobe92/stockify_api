require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe "Api::V1::Auth", type: :request do
  include ActiveJob::TestHelper 

  # Global variables
  let!(:user){ create(:user) }
  let!(:admin){ create(:admin) }

  # POST /LOGIN
  describe 'POST /login' do

    context 'with correct user login params' do

      before do

        user.update(activated: true)
        params = { email: user.email, password: user.password}
        post '/api/v1/auth/login', params: { auth: params}

      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the correct message' do
        expect(json['message']).to eq('Login successful')
      end

      it 'returns uid header' do
        expect(response.headers['Uid']).to match(user.id)
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

    context 'correct admin login params' do

      before do

        params = {email: admin.email, password: admin.password}
        post '/api/v1/auth/login', params: { auth: params}

      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the correct message' do
        expect(json['message']).to eq('Login successful')
      end

      it 'returns uid header' do
        expect(response.headers['Uid']).to match(admin.id)
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

    context 'with incorrect user login params' do

      it 'incorrect email returns 401 status' do
        params = { email: 'incorrect_email', password: user.password}
        post '/api/v1/auth/login', params: { auth: params}
        expect(response).to have_http_status(:unauthorized)
      end

      it 'incorrect password returns 401 status' do
        params = { email: user.email, password: 'incorrect_password'}
        post '/api/v1/auth/login', params: { auth: params}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with incorrect admin login params' do

      it 'incorrect email returns 401 status' do
        params = { email: 'incorrect_email', password: admin.password}
        post '/api/v1/auth/login', params: { auth: params}
        expect(response).to have_http_status(:unauthorized)
      end

      it 'incorrect password returns 401 status' do
        params = { email: admin.email, password: 'incorrect_password'}
        post '/api/v1/auth/login', params: { auth: params}
        expect(response).to have_http_status(:unauthorized)
      end
    end


    context 'with inactivated user login' do

      before do
        params = { email: user.email, password: user.password}
        post '/api/v1/auth/login', params: { auth: params}
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  # POST /PASSWORD_RESET
  describe 'POST /password_reset' do

    context 'with correct user password reset params' do

      before do

        params = {email: user.email}
        token = encode_reset_token(id: user.id)
        user.update(reset_token: token)

        perform_enqueued_jobs do
          post '/api/v1/auth/password_reset', params: {auth: params}
        end
        
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct message' do
        expect(json['message']).to eq("Password reset email for #{user.email}")
      end

      it 'generate and update the reset token for the user' do
        expect(user.reset_token).to be_present
      end

      it 'sends password reset email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    context 'with incorrect user password reset params' do

      before do

        params = {email: 'wrong_email'}
        post '/api/v1/auth/password_reset', params: {auth: params}

      end

      it 'returns a 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # PATCH /PASSWORD_UPDATE
  describe 'PATCH /password_update' do
    
    context 'with valid password update params' do

      before do

        token = encode_reset_token(id: user.id)
        user.update(reset_token: token)

        params = { password: 'passwords', password_confirmation: 'passwords' }
        patch "/api/v1/auth/password_update?token=#{token}", params: { auth: params }
        user.update(password: 'passwords', password_confirmation: 'passwords')

      end
    
      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end
    
      it 'updates the user password' do
        expect(user.authenticate('passwords')).to be_truthy
      end
    end

    context 'with invalid password update token' do

      before do

        expiry = (Time.now - 48.hours).iso8601()
        payload = {id: user.id, expiry: expiry}
        invalid_token = JWT.encode(payload, Rails.application.credentials.secret_key_base)
        params = {password: 'passwords', password_confirmation: 'passwords'}

        patch "/api/v1/auth/password_update?token=#{invalid_token}", params: {auth: params}
        
      end

      it 'returns a 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # POST /ACTIVATION
  describe 'POST /activation' do
    
    context 'with correct admin auth params' do
      before do

        params = {email: user.email}
        headers = { 'Authorization' => header(id: admin.id, account: 'admin') }

        perform_enqueued_jobs do
          post '/api/v1/auth/activation', params: { auth: params }, headers: headers
        end

      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'sends activation email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end 
    end

    context 'with incorrect user activation params' do

      before do

        params = {email: 'wrong_email'}
        headers = { 'Authorization' => header(id: admin.id, account: 'admin') }
        post '/api/v1/auth/activation', params: {auth: params}, headers: headers

      end

      it 'returns a 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end 

  # PATCH /ACTIVATE
  describe 'PATCH /activate' do
    
    context 'with valid activate params' do

      before do

        token = encode_activation_token(id: user.id)
        user.update(activation_token: token)

        patch "/api/v1/auth/activate?token=#{token}"
        user.update(activated: true)

      end
    
      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end
    
      it 'updates the user password' do
        expect(user.activated).to eq(true)
      end
    end

    context 'with invalid activation token' do

      before do

        expiry = (Time.now - 48.hours).iso8601()
        payload = {id: user.id, expiry: expiry}
        invalid_token = JWT.encode(payload, Rails.application.credentials.secret_key_base)

        patch "/api/v1/auth/activate?token=#{invalid_token}"
        
      end

      it 'returns a 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # POST CONFIGURE_OTP
  describe 'POST /configure_otp' do

    context 'with valid configure otp params' do

      before do

        headers = {"Authorization" => header(id: user.id, account: 'user')}
        get "/api/v1/auth/configure_otp/#{user.id}", headers: headers
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'generate and sends the key' do
        expect(json['key']).to be_present
      end

      it 'generate a provisioning uri' do
        expect(json['provisioning_uri']).to be_present
      end

      it 'generates a qr code' do
        expect(json['qrcode']).to be_present
      end
    end
  end

  # PATCH verify_otp
  describe 'PATCH /enable_otp' do
    
    context 'with valid enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(user.otp_secret_key)
        params = { otp: totp.now }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        patch "/api/v1/auth/enable_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)

      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns uid header' do
        expect(response.headers['Uid']).to match(user.id)
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

    context 'with invalid enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(user.otp_secret_key)
        params = { otp: totp.at(Time.now + 1.minute) }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        patch "/api/v1/auth/enable_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with empty enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(nil)
        params = { otp: totp }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        patch "/api/v1/auth/enable_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # POST VERIFY_OTP
  describe 'POST /enable_otp' do
    
    context 'with valid enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(user.otp_secret_key)
        params = { otp: totp.now }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        post "/api/v1/auth/verify_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)

      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns uid header' do
        expect(response.headers['Uid']).to match(user.id)
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

    context 'with invalid enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(user.otp_secret_key)
        params = { otp: totp.at(Time.now + 1.minute) }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        post "/api/v1/auth/verify_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with empty enable otp params' do
      
      before do

        # simulating that OTP is now add to the authenticator
        secret_key = ROTP::Base32.random
        user.update(otp_secret_key: secret_key)
        totp = ROTP::TOTP.new(nil)
        params = { otp: totp }

        headers = { 'Authorization' => header(id: user.id, account: 'user') }

        post "/api/v1/auth/verify_otp/#{user.id}", params: {auth: params}, headers: headers

        user.update(otp_enabled: true)
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end 
