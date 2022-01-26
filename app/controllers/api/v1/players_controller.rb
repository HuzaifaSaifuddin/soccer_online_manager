class Api::V1::PlayersController < ApplicationController
  before_action :authorize

  def update
    player = Player.find_by(id: params[:id])

    if player&.team_id.to_s == @user.team.id.to_s
      if player.update(player_params)
        head :accepted
      else
        render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['No Player found'] }, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :country_id)
  end
end
