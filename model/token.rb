#coding: utf-8
require 'securerandom'

class Token < Sequel::Model(:token)
  many_to_many :user, :join_table => :token_user

  def before_create
    self.token = SecureRandom.hex
    super
  end
end