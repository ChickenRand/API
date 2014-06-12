#coding: utf-8
require_relative "../helper"

describe User do
	it "Hashes passwords on creation and override ==" do
		u = User.create(email: "test@test.com", password:"test")
		u.password.to_s.should_not == "test"
		u.password.should == "test"
		u.password.is_password?("test").should == true
		u.password.is_password?("a").should == false
	end
end