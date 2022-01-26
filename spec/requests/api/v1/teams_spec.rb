require 'rails_helper'

RSpec.describe "Api::V1::Teams", type: :request do
  include RequestSpecHelper

  let(:user) { create(:user) }
  let(:headers) { { 'Authorization': login_user(user) } }

  describe 'Teams#Index' do
    it 'returns the user\'s team and players' do
      get "/api/v1/teams", headers: headers

      expect(JSON.parse(response.body)['team']['name']).to eq(user.team.name)
    end

    it 'raises Unauthorized if token doesnt exist' do
      get "/api/v1/teams", headers: { 'Authorization': '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      get "/api/v1/teams", headers: { 'Authorization': 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Teams#Update' do
    let(:team) { user.team }

    it 'updates an existing team' do
      team_name = Faker::Sports::Football.team
      put "/api/v1/teams/#{team.id}", headers: headers, params: { team: { name: team_name, country_id: 'in' } }

      team.reload
      expect(team.name).to eq(team_name)
      expect(team.country_id).to eq('in')
    end

    it 'raises ParameterMissing if user params is missing' do
      put "/api/v1/teams/#{team.id}", headers: headers, params: { team: {} }
      expect(response).to have_http_status(:bad_request)
    end

    it 'raises error message if params is empty or incorrect' do
      put "/api/v1/teams/#{team.id}", headers: headers, params: { team: { country_id: 'xx' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises error message if no team found (or team owner is different)' do
      put "/api/v1/teams/#{create(:team).id}", headers: headers, params: { team: { country_id: 'xx' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'raises Unauthorized if token doesnt exist' do
      put "/api/v1/teams/#{team.id}", headers: { 'Authorization': '' }, params: { team: { country_id: 'in' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'raises Unauthorized if token is incorrect' do
      put "/api/v1/teams/#{team.id}", headers: { 'Authorization': 'incorrect' }, params: { team: { country_id: 'in' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
