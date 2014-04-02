class Token < Sequel::Model(:token)
	many_to_many :user, :join_table => :token_user
end