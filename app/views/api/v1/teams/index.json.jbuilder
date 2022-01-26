json.set! "team" do
  json.name @team.name
  json.country @team.country.name
  json.value @team.value
end
json.set! "players" do
  json.array!(@players) do |player|
    json.full_name player.full_name
    json.country player.country.name
    json.age player.age
    json.position player.position
    json.market_value player.market_value
  end
end
