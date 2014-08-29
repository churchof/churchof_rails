require 'test_helper'

class InitiativeMetricsControllerTest < ActionController::TestCase
  setup do
    @initiative_metric = initiative_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:initiative_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create initiative_metric" do
    assert_difference('InitiativeMetric.count') do
      post :create, initiative_metric: {  }
    end

    assert_redirected_to initiative_metric_path(assigns(:initiative_metric))
  end

  test "should show initiative_metric" do
    get :show, id: @initiative_metric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @initiative_metric
    assert_response :success
  end

  test "should update initiative_metric" do
    patch :update, id: @initiative_metric, initiative_metric: {  }
    assert_redirected_to initiative_metric_path(assigns(:initiative_metric))
  end

  test "should destroy initiative_metric" do
    assert_difference('InitiativeMetric.count', -1) do
      delete :destroy, id: @initiative_metric
    end

    assert_redirected_to initiative_metrics_path
  end
end
