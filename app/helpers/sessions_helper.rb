module SessionsHelper

	# Logs in given user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Remembers a user in a persistant session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Returns a user in the persistent session
	def current_user?(user)
		user == current_user
	end

	#Forgets persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_tolken)
	end


	# Returns the current logged-in user (if any)
	def current_user
		if (user_id = session[:user_id]) # CAREFUL! (not ==). Read if session of user_id exists
			@current_user ||= User.find_by(id: user_id)
		else (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in(user)
				@current_user = user
			end
		end
	end

	# Returns true if the user is logged-in, else false
	def logged_in?
		!current_user.nil?
	end

	# logs out current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
end
