#coding: utf-8
require_relative '../helper'

describe QueueApi do
  include Rack::Test::Methods

  def app
    QueueApi
  end

  after :each do 
    puts JSON.parse(last_response.body)["error"] if @test
  end

  it "return the Queue state" do
    get('/queue/state').status.should == 200
    resp = JSON.parse(last_response.body)
    resp["estimated_time"].should == 0
    resp["length"].should == 0
  end

  it "Add a user to the queue" do
    xp = Xp.first
    #user need to be logged in
    post('/queue', {xp_id: xp.id}).status.should == 401
    login()
    post('/queue', {xp_id: xp.id}).status.should == 201
    #return GET /api/queue/:id
  end
end