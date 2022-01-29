class CreateTeam
  def self.call(user)
    team = user.build_team(name: Faker::Sports::Football.team, country_id: Country.random_id)

    return unless team.save

    { 'goalkeeper': 3, 'defender': 6, 'midfielder': 6, 'attacker': 5 }.each do |position, ps|
      ps.times do
        team.players.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                            country_id: Country.random_id, age: (18..40).to_a.sample, position: position)
      end
    end
  end
end
