ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Returns true if a test user is logged in 
  #(parallels logged_in? defined in session helper, but helpers methods are not available in tests, so current_user could not be use.  session method is available, so we use that. different name used to avoid confusion)
  def is_logged_in?
  	!session[:user_id].nil?
  end

  # Logs in a test user.

  def log_in_as(user, options={})
  	password = options[:password]				|| 'password'
  	remember_me = options[:remember_me]	|| '1'
  	if integration_test?
  		post login_path, session: { email: 				user.email,
  		  													password: 		password,
  		  													remember_me:  remember_me }	
  	else
  		session[:user_id] = user.id
  	end
  end

  private
    # Returns ture inside an integration test
    def integration_test?
      defined?(post_via_redirect)
    end
    



  # Add more helper methods to be used by all tests here...
end


