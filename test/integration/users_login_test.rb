require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:jack) # user from users.yml fixture
	end


	test 'login with invalid info flash persistance'	do
		get login_path				# Visit login path 
		assert_template 'sessions/new'	# Verify new session form renders properly
		post login_path session: {email: "", password:""} # post invalid params to the session path
		assert_template 'sessions/new' # Verify that the new sessions form gets re-rendered and that the flash message appears
		assert_not flash.empty?
		get root_path # Visit another page (home)
		assert flash.empty? # Verify flash message doesn't appear
	end

	test 'login with valid info followed by logout' do
		get login_path # visit login path
		post login_path, session: { email: @user.email, password: 'password' } # post valid info to the login path
		assert is_logged_in?
		assert_redirected_to @user # ensure user page loads
		follow_redirect!	# load user page
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0 # ensures no login link
		assert_select "a[href=?]", logout_path # ensures logout link
		assert_select "a[href=?]", user_path(@user)
		# logout testing
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url
		# Simulate a user clicking logout in a second window
		delete logout_path # should raise error due to missing current_user
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path,				count: 0
		assert_select "a[href=?]", user_path(@user),	count: 0
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_nil cookies['remember_tolken']
	end

	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_tolken']
	end

end
