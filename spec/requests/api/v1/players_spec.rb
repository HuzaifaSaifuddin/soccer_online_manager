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

    it 'raises error message if no player found' do
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

  describe 'Players#transfer' do
    let(:player) { create(:player, team: user.team) }

    it 'puts an existing player on transfer list' do
      patch "/api/v1/players/#{player.id}/transfer", headers: headers, params: { transfer_value: 1000000.0 }

      player.reload
      expect(player.transfer).to eq(true)
      expect(player.transfer_value).to eq(1000000.0)
    end

    it 'raises error if transfer_value is missing' do
      patch "/api/v1/players/#{player.id}/transfer", headers: headers, params: {}

      expect(response).to have_http_status(:bad_request)
    end

    it 'raises error if params is incorrect' do
      patch "/api/v1/players/#{player.id}/transfer", headers: headers, params: { transfer_value: -10 }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises Unauthorized if token doesnt exist' do
      patch "/api/v1/players/#{player.id}/transfer", headers: { 'Authorization': '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      patch "/api/v1/players/#{player.id}/transfer", headers: { 'Authorization': 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Player#buy' do
    let(:player) { create(:player, transfer: true, transfer_value: 1000000.0) }

    it 'transfers a player to the buyers team' do
      buyer_team = user.team
      buyer_team_balance = buyer_team.balance
      seller_team = player.team
      seller_team_balance = seller_team.balance
      player_market_value = player.market_value

      patch "/api/v1/players/#{player.id}/buy", headers: headers, params: {}

      player.reload
      buyer_team.reload
      seller_team.reload

      expect(player.team).to eq(buyer_team)
      expect(player.transfer).to_not eq(true)
      expect(player.transfer_value).to_not eq(1000000.0)
      expect(player.market_value).to be > player_market_value

      expect(buyer_team.balance).to eq(buyer_team_balance - 1000000.0)
      expect(seller_team.balance).to eq(seller_team_balance + 1000000.0)
    end

    it 'raises error if transaction fails' do
      player.set(first_name: '') # Purposely failing transaction by setting invalid value.

      buyer_team = user.team
      buyer_team_balance = buyer_team.balance
      seller_team = player.team
      seller_team_balance = seller_team.balance
      player_market_value = player.market_value

      patch "/api/v1/players/#{player.id}/buy", headers: headers, params: {}

      player.reload
      buyer_team.reload
      seller_team.reload

      # Checking if nothing has changed due to failed transaction
      expect(player.team).to eq(seller_team)
      expect(player.transfer).to eq(true)
      expect(player.transfer_value).to eq(1000000.0)
      expect(player.market_value).to eq(1000000.0)

      expect(buyer_team.balance).to eq(buyer_team_balance)
      expect(seller_team.balance).to eq(seller_team_balance)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises error if insufficient funds is missing' do
      player.update(transfer_value: user.team.balance + 1)
      patch "/api/v1/players/#{player.id}/buy", headers: headers, params: {}

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises Unauthorized if token doesnt exist' do
      patch "/api/v1/players/#{player.id}/buy", headers: { 'Authorization': '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      patch "/api/v1/players/#{player.id}/buy", headers: { 'Authorization': 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end    
  end
end
