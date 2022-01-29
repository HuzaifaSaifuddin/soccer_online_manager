class Api::V1::TransfersController < ApplicationController
  before_action :authorize

  def index
    @players = Player.includes(:country).where(transfer: true)

    render status: :ok
  end
end
