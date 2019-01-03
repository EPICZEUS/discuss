class Api::V1::UsersController < ApplicationController
	before_action :find_user, except: [:login, :create]

	def create
		@user = User.create(user_params)

		if @user.valid?
			render json: @user
		else
			render json: {
				error: true,
				messages: @user.errors.full_messages
			}
		end
	end

	def show
		render json: @user
	end

	def update
		if @user.authenticate(request.headers["Authorization"])
			if @user.update(user_params)
				render json: @user

				@user.rooms.each do |room|
					ActionCable.server.broadcast "room-#{room.id}", type: "userUpdate", user: @user
				end
			else
				render json: {
					error: true,
					messages: @user.errors.full_messages
				}
			end
		else
			render json: {
				error: true,
				status: 401,
				messages: ["Unauthorized"]
			}
		end
	end

	def login
		username, password = request.headers["Authorization"].split(":")

		@user = User.find_by(username: username)

		if !@user
			render json: {
				status: 404
			}
		elsif @user.authenticate(password)
			render json: {
				status: 200,
				id: @user.id
			}
		else
			render json: {
				status: 401
			}
		end
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		params.permit(:username, :password, :img_url, :first_name, :last_name)
	end
end
