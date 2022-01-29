require 'rails_helper'

RSpec.describe "Api::V1::Countries", type: :request do
  include RequestSpecHelper

  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': login_user(user) } }

  describe 'Countries#Index' do
    it 'returns list of countries' do
      get "/api/v1/countries", headers: headers

      expect(JSON.parse(response.body)['countries']['us']).to eq('United States')
    end

    it 'raises Unauthorized if token doesnt exist' do
      get "/api/v1/countries", headers: { 'Authorization': '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      get "/api/v1/countries", headers: { 'Authorization': 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
