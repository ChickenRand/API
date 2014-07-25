require './app'

#I didn't find how to do that with EventMachine...
timeout = Thread.new do
  while true
    Queue::check_inactive_items()
    sleep SEC_BETWEEN_QUEUE_CHECK
  end
end

main = Thread.new do
  run Rack::Cascade.new [UserApi, QueueApi, ResultsApi]
end

main.join