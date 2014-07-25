#coding: utf-8
require 'rspec'
require 'rack/test'
require 'rubygems'

require_relative '../app'

# On lance tous les tests dans une transaction ce qui fait
# que l'on a pas a supprimer quoique ce soit, sequel le fait pour nous :)

RSpec.configure do |c|
  c.around(:each) do |example|
    Sequel.transaction([DB], :rollback=>:always){example.run}
  end
  c.filter_run_excluding :broken => true

  I18n.config.enforce_available_locales = true

  c.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end

  c.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end

def fake_login()
    credentials = {email: 'test@test.com', password: 'test'}
    u = User.create(credentials)
    t = Token.create()
    rack_mock_session.cookie_jar['session_token'] = t.token
    u.add_token(t)
    u.save
end