require 'test_helper'

class EntryMetasControllerTest < ActionController::TestCase
  setup do
    @entry_meta = entry_metas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entry_metas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entry_meta" do
    assert_difference('EntryMeta.count') do
      post :create, :entry_meta => @entry_meta.attributes
    end

    assert_redirected_to entry_meta_path(assigns(:entry_meta))
  end

  test "should show entry_meta" do
    get :show, :id => @entry_meta.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @entry_meta.to_param
    assert_response :success
  end

  test "should update entry_meta" do
    put :update, :id => @entry_meta.to_param, :entry_meta => @entry_meta.attributes
    assert_redirected_to entry_meta_path(assigns(:entry_meta))
  end

  test "should destroy entry_meta" do
    assert_difference('EntryMeta.count', -1) do
      delete :destroy, :id => @entry_meta.to_param
    end

    assert_redirected_to entry_metas_path
  end
end
