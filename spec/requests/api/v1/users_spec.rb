require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'Users#create' do
    let(:params) { { email: Faker::Internet.email, password: 'Huzaifa@18' } }

    it 'returns the token' do
      post '/api/v1/users', params: { user: params }
      expect(JSON.parse(response.body)['token']).to_not eq(nil)
    end

    it 'creates a user' do
      post '/api/v1/users', params: { user: params }
      expect(response).to have_http_status(:created)
    end

    it 'raises ParameterMissing if user params is missing' do
      post '/api/v1/users'
      expect(response).to have_http_status(:bad_request)
    end

    it 'render error message if user params are missing or incorrect' do
      post '/api/v1/users', params: { user: { email: '', password: '' } }

      expect(JSON.parse(response.body)['errors']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises uniqueness error if email is taken' do
      new_user = create(:user)
      params[:email] = new_user.email

      post '/api/v1/users', params: { user: params }

      expect(JSON.parse(response.body)['errors'][0]).to eq('Email is already taken')
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
