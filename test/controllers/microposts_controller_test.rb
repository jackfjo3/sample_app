require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

	def setup
		@micropost = microposts(:post1)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Micropost.count' do
			post :create, micropost: {content: "this shoul not get posted"}
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy from wrong micropost" do
		log_in_as(users(:jack))
		micropost = microposts(:ants) # not jack's micropost
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: micropost
		end
		assert_redirected_to root_url
	end

end
