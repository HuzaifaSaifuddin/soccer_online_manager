class Api::V1::PlayersController < ApplicationController
  before_action :authorize
  before_action :set_player

  def update
    if @player.update(player_params)
      head :accepted
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def transfer
    params.require(:transfer_value)

    if @player.update(transfer: true, transfer_value: params[:transfer_value])
      head :accepted
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def buy
    if sufficient_balance?
      if TransferPlayer.call(@player, @user)
        head :accepted
      else
        render json: { errors: ['Something went wrong. Transfer unsuccessful.'] }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Insufficient Funds'] }, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :country_id)
  end

  def set_player
    @player = if params[:action] == 'buy'
                Player.find_by(id: params[:id], transfer: true, :team_id.ne => @user.team.id)
              else
                @user.team.players.find_by(id: params[:id])
              end

    render json: { errors: ['No Player found'] }, status: :unprocessable_entity if @player.nil?
  end

  def sufficient_balance?
    @user.team.balance.to_f >= @player.transfer_value.to_f
  end
end
