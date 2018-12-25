class Api::V1::UsersController < ApplicationController
	before_action :find_user, except: [:login]

	def show
		render json: @user
	end

	def update
		if @user.update(user_params)
			render json: @user

			@user.rooms.each do |room|
				ActionCable.server.broadcast "room-#{room.id}", {type: "userUpdate", user: @user}
			end
		end
	end

	def login
		@user = User.find_by(username: request.headers["username"])

		if @user.authenticate(request.headers["password"])
			render json: @user
		else
			render json: nil
		end
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		ActionController::Parameters.new(JSON.parse(request.body.string)).permit(:username, :password, :img_url, :first_name, :last_name)
	end
end
