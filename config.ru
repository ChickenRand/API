require './app'

run Rack::Cascade.new [UserApi, QueueApi, ResultsApi]