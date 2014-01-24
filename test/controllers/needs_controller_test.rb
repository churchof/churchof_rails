require 'test_helper'

class NeedsControllerTest < ActionController::TestCase
  setup do
    @need = needs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:needs)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:zach)
    get :new
    assert_response :success
  end

  test "should be logged in to post a need" do
    post :create, need: { title: "title" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create need when logged in" do
    sign_in users(:zach)
    assert_difference('Need.count') do
      post :create, need: { description: @need.description, title: @need.title }
    end
    assert_redirected_to need_path(assigns(:need))
  end

  test "should create need for the current user when logged in" do
    sign_in users(:zach)
    assert_difference('Need.count') do
      post :create, need: { description: @need.description, title: @need.title, user_id: users(:sam).id }
    end
    assert_redirected_to need_path(assigns(:need))
    assert_equal assigns(:need).user_id, users(:zach).id
  end

  test "should show need" do
    get :show, id: @need
    assert_response :success
  end

  test "should redirect need edit when not logged in" do
    get :edit, id: @need
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit when logged in" do
    sign_in users(:zach)
    get :edit, id: @need
    assert_response :success
  end

  test "should redirect need update when not logged in" do
    patch :update, id: @need, need: { description: @need.description, title: @need.title }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update need when logged in" do
    sign_in users(:zach)
    patch :update, id: @need, need: { description: @need.description, title: @need.title }
    assert_redirected_to need_path(assigns(:need))
  end

  test "should destroy need" do
    assert_difference('Need.count', -1) do
      delete :destroy, id: @need
    end

    assert_redirected_to needs_path
  end
end
