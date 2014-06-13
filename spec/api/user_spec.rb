#coding: utf-8
require_relative '../helper'

describe UserApi do
  include Rack::Test::Methods

  def app
  	UserApi
  end

  after :each do 
    puts JSON.parse(last_response.body)["error"] if @test
  end 

  def login
    credentials = {email: 'test@test.com', password: 'test'}
    u = User.create(credentials)
    post('/user/login', credentials).status.should == 201
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
    login()
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
    login()
    post("/user/logout").status.should == 201
    rack_mock_session.cookie_jar['session_token'].should == "deleted"
    User.first(email:'test@test.com').token.length.should == 0
  end

  it "Invite user and put them into the white list" do
    Pony.stub(:deliver)

    post('/user/invite', {emails:"test@test.com,test2@test.com"}).status.should == 201
    post('/user/invite', {emails:"test@test.com,test2@test.com"}).status.should == 201
    WhiteList.first(email:"test@test.com").should_not == nil
    WhiteList.first(email:"test2@test.com").should_not == nil
    WhiteList.where(email:"test2@test.com").count.should == 1
    expect(Pony).to receive(:deliver) do |mail|
      puts "yoooo"
      expect(mail.to).to eq [ 'test@test.com' ]
      #expect(mail.from).to eq [ 'sender@example.com' ]
      expect(mail.subject).to eq 'Invitation'
      #expect(mail.body).to eq 'Hello, Joe.'
    end
  end
end