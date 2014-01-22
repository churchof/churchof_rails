require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:zach).id
    assert_response :success
    assert_template 'profiles/show'
  end

  test "should render a 404 on full_name not found" do
    get :show, id: "not a user"
    assert_response :not_found
  end

  test "that variables are assigned on successful profile viewing" do
    get :show, id: users(:zach).id
    assert assigns(:user)
    assert assigns(:needs)
  end

  test "only shows the correct user's needs" do
    get :show, id: users(:zach).id
    assigns(:needs).each do |need|
    	assert_equal users(:zach), need.user
    end
  end

end
