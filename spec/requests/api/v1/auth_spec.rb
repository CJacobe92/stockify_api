require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /login" do
    context 'with correct credentials' do
      let!(:user){create(:user)}

      before do
        user
        post 'api/v1/auth', params: {email: user.email, password: user.password}
      end

      it 'returns a status of 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
