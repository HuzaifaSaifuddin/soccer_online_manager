require 'rails_helper'

RSpec.describe Player, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:player)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a first_name' do
      expect(build_stubbed(:player, first_name: nil)).to be_invalid
    end

    it 'is invalid without a last_name' do
      expect(build_stubbed(:player, last_name: nil)).to be_invalid
    end

    it 'is invalid without a country' do
      expect(build_stubbed(:player, country_id: nil)).to be_invalid
    end

    it 'is invalid without a age' do
      expect(build_stubbed(:player, age: nil)).to be_invalid
    end

    it 'is invalid without a position' do
      expect(build_stubbed(:player, position: nil)).to be_invalid
    end

    it 'is invalid if age is not between 18 to 40' do
      expect(build_stubbed(:player, age: 10)).to be_invalid
      expect(build_stubbed(:player, age: 50)).to be_invalid
    end

    it 'is invalid if position is not either of goalkeeper defender midfielder attacker' do
      expect(build_stubbed(:player, position: 'random')).to be_invalid
    end
  end

  describe 'full_name' do
    it 'returns the full_name of the player from first_name and last_name' do
      player = create(:player)

      expect(player.full_name).to eq("#{player.first_name} #{player.last_name}")
    end
  end
end
