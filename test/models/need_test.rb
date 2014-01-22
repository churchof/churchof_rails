require 'test_helper'

class NeedTest < ActiveSupport::TestCase

	test "that a need requires a title" do	
		need = Need.new
		assert !need.save
		assert !need.errors[:title].empty?
	end

	test "that a need requires a description" do	
		need = Need.new
		assert !need.save
		assert !need.errors[:description].empty?
	end

	test "that a need's description is at least 2 letters long" do	
		need = Need.new
		need.description = "a"
		assert !need.save
		assert !need.errors[:description].empty?
	end

	test "that a need has a user id" do	
		need = Need.new
		need.description = "abc"
		assert !need.save
		assert !need.errors[:user_id].empty?
	end
end
