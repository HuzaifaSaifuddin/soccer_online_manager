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

  def valid_token?
    !!current_user
  end

  def current_user
    token = request.headers['Authorization']
    decoded_array = JWT.decode(token, secret, true, { algorithm: 'HS256' })
    user_id = decoded_array[0]['user_id']

    @user ||= User.find_by(id: user_id)
  rescue JWT::DecodeError, JWT::VerificationError
    nil # Raises when token is empty or incorrect
  end

  def authorize
    render json: { error: 'Unauthorized' }, status: :unauthorized unless valid_token?
  end
end
