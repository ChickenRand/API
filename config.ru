require_relative 'app'

run Rack::Cascade.new [UserApi, QueueApi, ResultsApi]