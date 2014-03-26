#coding: utf-8
require_relative '../helper'

describe UserApi do
  include Rack::Test::Methods

  def app
  	UserApi
  end

  it "Return a user" do
  	u = User.create()
  	get("/user/#{u.id}").status.should == 200
  	JSON.parse(last_response.body)["id"].should == u.id
  end

  it "Return 405 on wrong user" do
  	get("/user/12356").status.should == 405
  end

  it "login a user" do
  	credentials = {email: "test@test.com", password: "test"}
  	u = User.create(credentials)
  	post("/user/login", credentials).status.should == 201
  end
end