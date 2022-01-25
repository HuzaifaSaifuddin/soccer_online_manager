FactoryBot.define do
  factory :team do
    name { Faker::Sports::Football.team }
    country_id { Country.random_id }
    user { create(:user) }
  end
end
