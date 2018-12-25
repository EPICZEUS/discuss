class ApplicationController < ActionController::API
	def current_user
		User.find_by(id: request.headers["Auth"])
	end

	def logged_in?
		!!current_user
	end
end
