class UserApi < Grape::API
  prefix "user"
  format :json
  get ':id' do
    test = params[:id]
    message = "User Not Found"
    user = User[test]
    error!(message, 405) if user.nil?
    user.values
  end
  post ':login' do
    puts "Sa marche"
    cookies[:session_token] = "toot"
  end
end
