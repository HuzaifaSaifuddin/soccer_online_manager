FactoryBot.define do
  factory :player do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country_id { Country.random_id }
    age { (18..40).to_a.sample }
    position { %w[goalkeeper defender midfielder attacker].sample }
    team { create(:team) }
  end
end
