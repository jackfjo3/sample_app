require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:jack)
	end

	test "password resets" do 
		get new_password_reset_path
		assert_template 'password_resets/new'
		# invalid email
		post password_resets_path, password_reset: { email: "" }
		assert_not flash.empty?
		assert_template 'password_resets/new'
		# valid email
		post password_resets_path, password_reset: { email: @user.email }
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url
		# password reset form
		user = assigns(:user) #?? why do we need to do this when we have @user used in rb 18
		# wrong email
		get edit_password_reset_path(user.reset_token, email: "")
		assert_redirected_to root_url
		# inactive user
		user.toggle!(:activated) #?? thought strong parameters prevented this?
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_redirected_to root_url
		user.toggle!(:activated)
		# right email wrong token
		get edit_password_reset_path('wrong token', email: user.email)
		assert_redirected_to root_url
		# right email and right token
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_template 'password_resets/edit'
		assert_select "input[name=email][type=hidden][value=?]", user.email
		# invalid password and confirmation
		patch password_reset_path(user.reset_token),
			email: user.email,
			user: { password: 						 "password",
							password_confirmation: "not_confirmed" }
		assert_select 'div#error_explanation' #?? difference between this and assert_not flash.empty
		# blank password
		patch password_reset_path(user.reset_token),
			email: user.email,
			user: { password: 							"  ",
							password_confirmation: 	"not_blank" }
		assert_not flash.empty?
		assert_template 'password_resets/edit'
		# valid password and confirmation
		patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

end
