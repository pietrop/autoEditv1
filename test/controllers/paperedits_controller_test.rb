require 'test_helper'

class PapereditsControllerTest < ActionController::TestCase
  setup do
    @paperedit = paperedits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paperedits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paperedit" do
    assert_difference('Paperedit.count') do
      post :create, paperedit: { projectname: @paperedit.projectname }
    end

    assert_redirected_to paperedit_path(assigns(:paperedit))
  end

  test "should show paperedit" do
    get :show, id: @paperedit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @paperedit
    assert_response :success
  end

  test "should update paperedit" do
    patch :update, id: @paperedit, paperedit: { projectname: @paperedit.projectname }
    assert_redirected_to paperedit_path(assigns(:paperedit))
  end

  test "should destroy paperedit" do
    assert_difference('Paperedit.count', -1) do
      delete :destroy, id: @paperedit
    end

    assert_redirected_to paperedits_path
  end
end
