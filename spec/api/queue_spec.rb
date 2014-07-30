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
    @test = true
    xp = Xp.create(name: "test", estimated_time: 200)
    get('/queue/state').status.should == 200
    resp = JSON.parse(last_response.body)
    resp["estimated_time"].should == 0
    resp["length"].should == 0
    fake_login()
    post('/queue', {xp_id: xp.id})
    get('/queue/state').status.should == 200
    resp = JSON.parse(last_response.body)
    resp["length"].should == 1
    resp["estimated_time"].should == 200
  end

  it "Add a user to the queue and increment queue item id" do
    xp = Xp.create(name: "test")
    #user need to be logged in
    post('/queue', {xp_id: xp.id}).status.should == 401
    fake_login()
    post('/queue', {xp_id: xp.id}).status.should == 201
    resp = JSON.parse(last_response.body)
    post('/queue', {xp_id: xp.id}).status.should == 201
    resp2 = JSON.parse(last_response.body)
    resp2["id"].should == resp["id"] + 1
  end
end