class UserApi < Grape::API
  prefix "user"
  format :json
  get ':id' do
    id = params[:id]
    message = "User Not Found"
    user = User[id]
    error!(message, 405) if user.nil?
    user.values
  end
  post ':login' do
    cookies[:session_token] = "toot"
  end
end
