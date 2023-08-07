require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do

  describe 'GET /index' do
    context 'with correct authorization' do
      let!(:users){create_list(:user, 10)}

      before do
        users
        get '/api/v1/users'
      end

      it 'returns a the correct number of users' do
        expect(json['data'].size).to eq(10)
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/index')
      end

      it 'returns the index json with the expected keys' do
        assert_users_keys(json['data'])
      end
    end  
  end

  describe 'POST /create' do
    context 'with valid user params' do
      before do
        post '/api/v1/users', params: {user: attributes_for(:user)}
      end

      it 'returns a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/create')
      end

      it 'returns the create json with the expected keys' do 
        assert_user_keys(json['data'])
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
    context 'with correct authorization' do
      
      let!(:user){create(:user)}

      before do
        user
        get "/api/v1/users/#{user.id}"
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/show')
      end

      it 'returns the show json with the expected keys' do 
        assert_user_keys(json['data'])
      end
    end
  end

  describe 'PATCH /update' do
    context 'with correct authorization' do

      let!(:user){create(:user)}
      updated_user_params = {email: 'john.weak@example.com'}

      before do
        patch "/api/v1/users/#{user.id}", params: {user: updated_user_params}
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/users/update')
      end

      it 'returns the show json with the expected keys' do 
        assert_user_keys(json['data'])
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with correct authorization' do

      let!(:user){create(:user)}

      before do
        delete "/api/v1/users/#{user.id}"
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
  # Helper methods

  def assert_users_keys(data)
    expect(data.size).to eq(10)
  end

  def assert_user_keys(data)
    expect(data.size).to eq(6)
  end

end
