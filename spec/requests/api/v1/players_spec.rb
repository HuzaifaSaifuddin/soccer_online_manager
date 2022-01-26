require 'rails_helper'

RSpec.describe "Api::V1::Players", type: :request do
  include RequestSpecHelper

  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': login_user(user) } }

  describe 'Players#Update' do
    let(:player) { create(:player, team: user.team) }

    it 'updates an existing player' do
      params = { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, country_id: 'in' }
      put "/api/v1/players/#{player.id}", headers: headers, params: { player: params }

      player.reload
      expect(player.first_name).to eq(params[:first_name])
      expect(player.last_name).to eq(params[:last_name])
      expect(player.country_id).to eq('in')
    end

    it 'raises ParameterMissing if user params is missing' do
      put "/api/v1/players/#{player.id}", headers: headers, params: { player: {} }
      expect(response).to have_http_status(:bad_request)
    end

    it 'raises error message if params is empty or incorrect' do
      put "/api/v1/players/#{player.id}", headers: headers, params: { player: { country_id: 'xx' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises error message if no player found (or player owner is different)' do
      put "/api/v1/players/#{create(:player).id}", headers: headers, params: { player: { country_id: 'in' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises Unauthorized if token doesnt exist' do
      put "/api/v1/players/#{player.id}", headers: { 'Authorization': '' }, params: { player: { country_id: 'in' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      put "/api/v1/players/#{player.id}", headers: { 'Authorization': 'incorrect' }, params: { player: { country_id: 'in' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
