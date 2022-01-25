class Api::V1::SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:email], params[:password])

    if user
      render json: { token: token(user.id), user_id: user.id }, status: :created
    else
      render json: { errors: ['Username or Password is incorrect'] }, status: :unprocessable_entity
    end
  end
end
