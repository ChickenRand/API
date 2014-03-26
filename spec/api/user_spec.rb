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
end