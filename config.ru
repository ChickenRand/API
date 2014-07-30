require './app'

#I didn't find how to do that with EventMachine...
timeout = Thread.new do
  while true
    Queue::check_inactive_items()
    sleep Configuration::SEC_BETWEEN_QUEUE_CHECK
  end
end

main = Thread.new do
  # Root maps to the documentation of the other apis
  map "/api" do
    #run Rack::Cascade.new [UserApi, QueueApi, ResultsApi, XpApi]
    run Root
  end

  map "/" do
    run Rack::File.new("./public")
  end
end

main.join