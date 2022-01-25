class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :params_missing

  def params_missing(exception)
    render json: { errors: [exception.message] }, status: :bad_request
  end

  private

  def token(user_id)
    payload = { user_id: user_id }
    JWT.encode(payload, secret, 'HS256')
  end

  def secret
    'my$ecretK3y'
  end
end
