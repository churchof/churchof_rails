require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
	test "that /login route opens the login page" do
		get '/login'
		assert_response :success
	end

	test "that a profile page works" do
		get '/1'
		assert_response :success
	end
end
