class TransferPlayer
  class << self
    def call(player, user)
      # Reduce transfer balance from buyer's team
      buyer_team = Team.find_by(id: user.team.id)
      buyer_team.balance -= player.transfer_value

      # Add transfer income to seller's team
      seller_team = Team.find_by(id: player.team_id)
      seller_team.balance += player.transfer_value

      # Update player's team, market value & reset transfer fields
      execute_transfer(player, buyer_team)

      return false if buyer_team.invalid? || seller_team.invalid? || player.invalid?

      buyer_team.save && seller_team.save && player.save
    end

    private

    def execute_transfer(player, buyer_team)
      player.market_value += ((player.market_value * (10..100).to_a.sample) / 100)
      player.team_id = buyer_team.id
      player.transfer = false
      player.transfer_value = 0
    end
  end
end
