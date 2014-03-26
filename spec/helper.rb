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
end