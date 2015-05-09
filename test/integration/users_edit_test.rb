require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:jack)
	end

	test "unsuccessful edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: 	{ name: 		"",
																			email: 		"foo@invalid",
																			password: 							"foo",
																			password_confirmation: 	"bar"	}
		assert_template 'users/edit'
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
		patch user_path(@user), user: 	{ name: "name",
																			email: "email",
																			password: 		 					"",			
																			password_confirmation: 	""	}
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal @user.name, "name"
		assert_equal @user.email, "email"
		# To ensure subsequent logins bring up user page and not edit page
		log out
		log_in_as(@user)
		assert_redirected_to @user
	end



end
