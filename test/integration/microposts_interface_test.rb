require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:jack)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
  	# invalid submission
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'
  	# valid submission
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: { content: "content" } #?? difference between micropost_path and microposts_path?
  	end
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match "content", response.body
  	# delete post
  	assert_select "a", text: 'delete'
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost) #?? difference between micropost_path and microposts_path?
  	end
  	# visit a different user
  	get user_path users(:user_4)
  	assert_select 'a', text: 'delete', count: 0
  end

end
