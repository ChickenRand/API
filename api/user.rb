#coding: utf-8
class UserApi < Grape::API
  helpers LoginHelpers
  prefix "user"
  format :json
  #content_type :json, "application/json; charset=utf-8"
  default_error_formatter :json
  default_error_status 400

  # Tout erreur de validation est gérée à ce niveau
  # Va renvoyer le message d'erreur au format json
  # avec le default error status
  rescue_from :all
  
  get ':id' do
    id = params[:id]
    message = "User Not Found"
    user = User[id]
    error!(message, 405) if user.nil?
    user.values
  end

  desc 'Log a user in.'
  params do
    requires :email, type: String
    requires :password, type: String
  end
  post ':login' do
    u = User.first(email: params[:email])
    error!('User not found', 404) if u.nil? or u.password != params[:password]
    t = Token.create()
    cookies[:session_token] = t.token
    u.add_token(t)
    u.save
  end

  desc 'Create a new user.'
  params do
    requires :email, type: String
    requires :password, type: String
    optional :age, type: Integer
    optional :laterality, type: String
    optional :believer, type: String
    optional :sex, type: String
  end
  post do
    User.create do |u|
      u.email = params[:email]
      u.password = params[:password]
      u.age = params[:age]
      u.laterality = params[:laterality]
      u.believer = params[:believer]
      u.sex = params[:sex]
    end
  end

  desc 'Modify a user.'
  params do
    optional :password, type:  String
    optional :age, type: Integer
    optional :laterality, type: String
    optional :believer, type: String
    optional :sex, type: String
  end
  put do
    authenticate!
    declared(params, include_missing: false).each do |k,v|
      if @current_user.respond_to?(k.to_sym)
        @current_user.set(k.to_sym => v)
      end  
    end
    @current_user.save()
  end
end
