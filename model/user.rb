class User < Sequel::Model(:user)
	many_to_many :token, :join_table => :token_user
end