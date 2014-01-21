require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test "a new user should have a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a new user should have a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end
end
