require 'rails_helper'

RSpec.describe "Api::V1::Admins", type: :request do
  let!(:admin){create(:admin)}

  describe 'GET /index' do
    context 'with correct authorization' do

      before do
        create_list(:admin, 9)
        get '/api/v1/admins', headers: { 'Authorization' => header(id: admin.id, account: 'admin') }

      end

      it 'returns a the correct number of administrators' do
        expect(json['data'].size).to eq(10)
      end

      it 'returns http status of 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/admins/index')
      end

      it 'returns the index json with the expected keys' do
        assert_admins_keys(json['data'])
      end
    end  
  end

  describe 'POST /create' do
    context 'with valid administrator params' do
      let(:admin_attributes) { attributes_for(:admin) }

      before do
        post '/api/v1/admins', params: { admin: admin_attributes }
      end

      it 'returns a 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/admins/create')
      end

      it 'returns the create json with the expected keys' do 
        assert_admin_keys(json['data'])
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

    context 'with invalid administrator params' do

      before do
        post '/api/v1/admins', params: {admin: attributes_for(:incorrect_admin)}
      end

      it 'returns a 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /show' do
    context 'with correct authorization' do

      before do
        get "/api/v1/admins/#{admin.id}", headers: { 'Authorization' => header(id: admin.id, account: 'admin') }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/admins/show')
      end

      it 'returns the show json with the expected keys' do 
        assert_admin_keys(json['data'])
      end
    end
  end

  describe 'PATCH /update' do
    context 'with correct authorization' do

      before do
        updated_admin_params = {email: 'john.weak@example.com'}
        patch "/api/v1/admins/#{admin.id}", params: {admin: updated_admin_params}, headers: { 'Authorization' => header(id: admin.id, account: 'admin') }
      end

      it 'returns a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the view template' do
        expect(response).to render_template('api/v1/admins/update')
      end

      it 'returns the show json with the expected keys' do 
        assert_admin_keys(json['data'])
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'with correct authorization' do

      before do
        delete "/api/v1/admins/#{admin.id}", headers: { 'Authorization' => header(id: admin.id, account: 'admin') }
      end

      it 'returns a 204 status' do
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  # Helper methods

  def assert_admins_keys(data)
    expect(data.size).to eq(10)
  end

  def assert_admin_keys(data)
    expect(data.size).to eq(6)
  end
end
