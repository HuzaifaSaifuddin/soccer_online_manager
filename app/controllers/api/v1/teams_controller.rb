class Api::V1::TeamsController < ApplicationController
  before_action :authorize
  before_action :set_team

  def index
    @players = @team.players.includes(:country).where(transfer: false)

    render status: :ok
  end

  def update
    if owner?
      if @team.update(team_params)
        head :accepted
      else
        render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ['Only owner can update their team'] }, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :country_id)
  end

  def set_team
    @team = @user.team

    render json: { errors: ['No Team found'] }, status: :unprocessable_entity if @team.nil?
  end

  def owner?
    @team&.id.to_s == params[:id]
  end
end
