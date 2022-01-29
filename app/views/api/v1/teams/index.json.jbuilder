json.set! 'team' do
  json.id @team.id
  json.name @team.name
  json.country @team.country.name
  json.balance @team.balance
  json.no_of_players @players.count
  json.value @team.value
end

json.set! 'players' do
  json.array!(@players) do |player|
    json.id player.id
    json.full_name player.full_name
    json.country player.country.name
    json.age player.age
    json.position player.position
    json.market_value player.market_value
    json.transfer player.transfer
    json.transfer_value player.transfer_value if player.transfer
  end
end
