require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'Sessions#create' do
    it 'creates a session if email & password are correct' do
      new_user = create(:user)
      new_user.send(:encrypt_password)

      post '/api/v1/sessions', params: { email: new_user.email, password: new_user.password }
      expect(response).to have_http_status(:created)
    end

    it 'doesnt creates a session if email or password is incorrect' do
      post '/api/v1/sessions', params: { email: 'incorrect-email', password: 'incorrect-password' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
