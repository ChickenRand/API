#coding: utf-8
require_relative '../helper'

describe UserApi do
  include Rack::Test::Methods

  def app
  	UserApi
  end

  it "Returns a specific user" do
  	u = User.create({email: 'test@test.com', password: 'test'})
  	get("/user/#{u.id}").status.should == 200
  	JSON.parse(last_response.body)["id"].should == u.id
  end

  it "Returns current logged user" do
  end

  it "Return 405 on wrong user" do
  	get("/user/12356").status.should == 405
  end

  it "login a user with a cookie" do
  	credentials = {email: 'test@test.com', password: 'test'}
  	u = User.create(credentials)
  	post('/user/login', credentials).status.should == 201
  	rack_mock_session.cookie_jar['session_token'].should_not == nil
    post('/user/login', {toto: "toto"}).status.should == 400
    post('/user/login', {email: 'toto', password: 'toto'}).status.should == 404
  end

  it "Create a user" do
  	data = {email: 'test@test.com', password: 'test', age: 25, laterality: 'left', believer: true, sex: 'F'}
  	post("/user", data).status.should == 201
  	# You can't create two users with the same email address
  	post("/user", data).status.should == 400
    JSON.parse(last_response.body)["error"].should_not == nil
  	User.first(email:'test@test.com').age.should == 25
  end

  it "Modify a user" do
  	credentials = {email: "test@test.com", password: "test"}
  	u = User.create(credentials)
  	#Needs to be login
  	put("/user", {age: 19}).status.should == 401
  	post("/user/login", credentials)
    put("/user", {age: 19}).status.should == 200
    User.first(email:'test@test.com').age.should == 19
    put("/user", {age: 23}).status.should == 200
    User.first(email:'test@test.com').age.should == 23	
  end

  it "logout a user" do

  end
end