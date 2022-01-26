module RequestSpecHelper
  def login_user(user)
    post '/api/v1/sessions', params: { email: user.email, password: user.password }

    JSON.parse(response.body)['token'] # return
  end
end
