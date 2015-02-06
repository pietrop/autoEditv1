require 'test_helper'

class PapercutsControllerTest < ActionController::TestCase
  setup do
    @papercut = papercuts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:papercuts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create papercut" do
    assert_difference('Papercut.count') do
      post :create, papercut: { comment: @papercut.comment, line_id: @papercut.line_id, paperedit_id: @papercut.paperedit_id, position: @papercut.position }
    end

    assert_redirected_to papercut_path(assigns(:papercut))
  end

  test "should show papercut" do
    get :show, id: @papercut
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @papercut
    assert_response :success
  end

  test "should update papercut" do
    patch :update, id: @papercut, papercut: { comment: @papercut.comment, line_id: @papercut.line_id, paperedit_id: @papercut.paperedit_id, position: @papercut.position }
    assert_redirected_to papercut_path(assigns(:papercut))
  end

  test "should destroy papercut" do
    assert_difference('Papercut.count', -1) do
      delete :destroy, id: @papercut
    end

    assert_redirected_to papercuts_path
  end
end
