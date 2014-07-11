require 'rubygems'
require 'sequel'
require 'grape'

require_relative 'config/init'
require_relative 'model/init'
require_relative 'api/init'

EventMachine.run {
  EventMachine.add_periodic_timer( 5 ) { Queue::check_inactive_items() }
}