#coding: utf-8
require_relative '../helper'

describe XpApi do
  include Rack::Test::Methods

  def app
    XpApi
  end

  after :each do 
    puts JSON.parse(last_response.body)["error"] if @test
  end

  it "return all XP's" do
    Xp.create(name: "test")
    get("/xp").status.should == 200
    JSON.parse(last_response.body)[-1]['name'].should == "test"
  end
end