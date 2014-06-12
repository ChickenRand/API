#coding: utf-8
module LoginHelpers
	def current_user
		token = cookies[:session_token]
		@current_user = User.first(:token=>Token.first(:token => token))
	end

	def authenticate!
		error!('Non authenticate', 401) unless current_user
	end
end