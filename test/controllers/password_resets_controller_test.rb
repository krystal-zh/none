require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  def setup
    super
    @user = User.first
    @user.create_reset_digest
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, email: @user.email, id: @user.reset_token
    assert_response :success
  end

end
