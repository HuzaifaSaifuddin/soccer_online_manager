require 'rails_helper'

RSpec.describe "Api::V1::Transfers", type: :request do
  include RequestSpecHelper

  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': login_user(user) } }

  describe 'Transfers#Index' do
    it 'returns list of transfer players' do
      player = create(:player, transfer: true, transfer_value: 1000000.0)

      get "/api/v1/transfers", headers: headers
      expect(JSON.parse(response.body)['players'][0]['full_name']).to eq(player.full_name)
    end

    it 'raises Unauthorized if token doesnt exist' do
      get "/api/v1/transfers", headers: { 'Authorization': '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      get "/api/v1/transfers", headers: { 'Authorization': 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
