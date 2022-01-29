require 'rails_helper'
require './spec/concerns/validate_country_spec.rb'

RSpec.describe Team, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:team)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a name' do
      expect(build_stubbed(:team, name: nil)).to be_invalid
    end

    it 'is invalid without a country' do
      expect(build_stubbed(:team, country_id: nil)).to be_invalid
    end

    it 'is invalid without a user' do
      expect(build_stubbed(:team, user_id: nil)).to be_invalid
    end
  end

  describe 'value' do
    it 'returns the total value of all players in the team' do
      team = create(:team)
      players = create_list(:player, 5, team_id: team.id.to_s)
      expect(team.value).to eq(5000000.0)
    end
  end

  it_behaves_like 'validate_country'
end
