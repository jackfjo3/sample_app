class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		log_in user # Log the user in and redirect to the user's showpage
  		params[:session][:remember_me] == '1' ? remember(user) : forget(user)
  		redirect_back_or user
  	else
  		# Show error message
  		flash.now[:danger] = 'Wrong email or password' 
  		render 'new'
  	end
 	end

 	def destroy
    log_out if logged_in?    # not logging out
    redirect_to root_url
  end
end
