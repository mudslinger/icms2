require 'test_helper'

class AppConfigsControllerTest < ActionController::TestCase
  setup do
    @app_config = app_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_config" do
    assert_difference('AppConfig.count') do
      post :create, :app_config => @app_config.attributes
    end

    assert_redirected_to app_config_path(assigns(:app_config))
  end

  test "should show app_config" do
    get :show, :id => @app_config.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @app_config.to_param
    assert_response :success
  end

  test "should update app_config" do
    put :update, :id => @app_config.to_param, :app_config => @app_config.attributes
    assert_redirected_to app_config_path(assigns(:app_config))
  end

  test "should destroy app_config" do
    assert_difference('AppConfig.count', -1) do
      delete :destroy, :id => @app_config.to_param
    end

    assert_redirected_to app_configs_path
  end
end
