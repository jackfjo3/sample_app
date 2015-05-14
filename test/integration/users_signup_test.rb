require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, user: {name: "",
  														email: "user@invalid",
  														password: "foo",
  														password_confirmation: "bar" }
  	end
  	assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid signup information with account activation" do 
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "test name",
                                            email: "testname@test.com",
                                            password: "password",
                                            password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as user
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token wrong email
    get edit_account_activation_path(user.activation_token, email:'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, password_reset: { email: @user.email }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago )
    patch password_reset_path(@user_reset_token),
        email: @user.email
        user: { password:              "foobar",
                password_confirmation: "foobar" }
    assert_response :follow_redirect
    follow_redirect!
    assert_match "expired", response.body
  end


end