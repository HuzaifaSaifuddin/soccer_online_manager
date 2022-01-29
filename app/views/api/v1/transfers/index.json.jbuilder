user_team_id = @user.team.id
json.set! 'players' do
  json.array!(@players) do |player|
    json.id player.id
    json.full_name player.full_name
    json.country player.country.name
    json.age player.age
    json.position player.position
    json.market_value player.market_value
    json.transfer_value player.transfer_value
    json.owned user_team_id == player.team_id # Mark Patient as owned by the current user
  end
end
