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

  # Add more helper methods to be used by all tests here...
end
