require 'rails_helper'
require 'sidekiq/testing'
require 'pry'

RSpec.describe "Api::V1::Users", type: :request do
  include ActiveJob::TestHelper 

  describe 'GET /index' do

    context 'with correct administrator authorization' do

      let!(:users){create_list(:user, 10)}
      let!(:admin){create(:admin)}
      let(:stock) { create(:stock) }
      let(:sp) { create(:stock_price, stock: stock) }
      let(:account) { create(:account) }

      before do
        generate_users_data(users)
        get '/api/v1/users', headers: { 'Authorization' => header({id: admin.id, account: 'admin'}) }

      end

      it 'returns a the correct number of users to view for the administrator' do
        expect(json['data'].size).to eq(10)
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok) 
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/index')
      end

      it 'returns the users json with the expected keys' do
        json['data'].map do |user|
          expect(user.size).to eq(10)
        end
      end

      it 'returns the accounts keys with the expected keys' do
        json['data'].map do |user|
          user['accounts'].map do |account|
            if account['transactions'].present? && account['portfolios'].present?
              expect(account.size).to eq(8)
            end
          end
        end
      end

      it 'returns the transaction keys with the expected keys' do
        json['data'].map do |user|
          user['accounts'].map do |account|
            if account['transactions'].present?
              account['transactions'].map do |transaction|
                expect(transaction.size).to eq(11)
              end
            end
          end
        end
      end

      it 'returns the portfolios keys with the expected keys' do
        json['data'].map do |user|
          user['accounts'].map do |account|
            if account['portfolios'].present?
              account['portfolios'].map do |portfolio|
                expect(portfolio.size).to eq(14)
              end
            end
          end
        end
      end
    
    end  
  end

  describe 'POST /create' do
    context 'with valid user params' do
      let(:user_attributes) { attributes_for(:user) }

      before do
        perform_enqueued_jobs do
          post '/api/v1/users', params: { user: user_attributes }
        end
      end

      it 'returns a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'sends welcome email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end 

      it 'returns the user json with the expected keys' do
        expect(json['message']).to eq('Registration successful')
      end
    end

    context 'with invalid user params' do

      before do
        post '/api/v1/users', params: {user: attributes_for(:incorrect_user)}
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'with correct user authorization' do
      
      let!(:user){create(:user)}
      let!(:other_user){create(:user)}

      before do
        generate_user_data(user)

        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => header({id: user.id, account: 'user'}) }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/show')
      end

      it 'returns the user json with the expected keys' do
        expect(json['data'].size).to eq(7)
      end
    end

    context 'with incorrect user resource access' do

         
      let!(:user){create(:user)}
      let!(:other_user){create(:user)}

      before do
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => header({id: other_user.id, account: 'user'}) }
      end

      it 'returns a 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json['error']).to include('Unauthorized resource access')
      end
    end

    context 'with correct admin authorization' do

      let!(:user){create(:user)}
      let!(:admin){create(:admin)}

      before do
        get "/api/v1/users/#{user.id}", headers: { 'Authorization' => header({id: admin.id, account: 'admin'}) }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/show')
      end

      it 'returns the user json with the expected keys' do
        expect(json['data'].size).to eq(7)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with correct authorization' do

      let!(:user){create(:user)}

      before do
        updated_user_params = {email: 'john.weak@example.com'}
        patch "/api/v1/users/#{user.id}", params: {user: updated_user_params}, headers: { 'Authorization' => header({id: user.id, account: 'user'}) }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/update')
      end

      it 'returns the show json with the expected keys' do 
        expect(json['data'].size).to eq(6)
      end
    end

    context 'with incorrect user resource access' do

      let!(:user){create(:user)}
      let!(:other_user){create(:user)}
      let!(:admin){create(:admin)}

      before do
        updated_user_params = {email: 'john.weak@example.com'}
        patch "/api/v1/users/#{user.id}", params: {user: updated_user_params}, headers: { 'Authorization' => header({id: other_user.id, account: 'user'}) }
      end

      it 'returns a 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(json['error']).to include('Unauthorized resource access')
      end
    end

    context 'with correct admin authorization' do

      let!(:user){create(:user)}
      let!(:admin){create(:admin)}

      before do
        updated_user_params = {email: 'john.weak@example.com'}
        patch "/api/v1/users/#{user.id}", params: {user: updated_user_params}, headers: { 'Authorization' => header({id: admin.id, account: 'admin'}) }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/update')
      end

      it 'returns the show json with the expected keys' do 
        expect(json['data'].size).to eq(6)
      end
    end

    
  end

  describe 'DELETE /destroy' do

    context 'with correct authorization' do

      let!(:user){create(:user)}
      let!(:admin){create(:admin)}

      before do
        delete "/api/v1/users/#{user.id}", headers: { 'Authorization' => header({id: admin.id, account: 'admin'}) }
      end

      it 'returns a 204 status' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with incorrect admin authorization' do

      let!(:user){create(:user)}

      before do
        updated_user_params = {email: 'john.weak@example.com'}
        delete "/api/v1/users/#{user.id}", params: {user: updated_user_params}, headers: { 'Authorization' => header({id: user.id, account: 'user'}) }
      end

      it 'returns a 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  def generate_users_data(users)
    stock = create(:stock) do |s|
      create(:stock_price, stock: s)
    end

    users.each do |user|
      user.accounts.map do |account| 
        create(:buy, account: account, stock: stock)
      end
    end
  end

  def generate_user_data(user)
    stock = create(:stock) do |s|
      create(:stock_price, stock: s)
    end

    user.accounts.map do |account| 
      create_list(:buy, 2, account: account, stock: stock)
    end
  end
  

end
