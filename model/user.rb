#coding: utf-8
require 'bcrypt'

class User < Sequel::Model(:user)
  plugin :validation_helpers
  many_to_many :token, :join_table => :token_user

  def validate
    super
    validates_presence [:email, :password]
    validates_unique :email
  end

  def password
    BCrypt::Password.new(super)
  end

  # Utilise l'algorithme BCrypt pour haser le mot de passe
  def password= (pass)
    super(BCrypt::Password.create(pass))
  end
end