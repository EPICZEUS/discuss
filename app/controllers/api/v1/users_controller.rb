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
		if @user.authenticate(user_params[:password])
			if @user.update(user_update_params)
				render json: @user

				@user.rooms.each do |room|
					ActionCable.server.broadcast "room-#{room.id}", {type: "userUpdate", user: @user}
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
				status: 403
			}
		end
	end

	def login
		@user = User.find_by(username: request.headers["username"])

		if !@user
			render json: {
				status: 404
			}
		elsif @user.authenticate(request.headers["password"])
			render json: {
				status: 200,
				id: @user.id
			}
		else
			render json: {
				status: 403
			}
		end
	end

	private

	def find_user
		@user = User.find(params[:id])
	end

	def user_params
		ActionController::Parameters.new(JSON.parse(request.body.string)).permit(:username, :password, :img_url, :first_name, :last_name)
	end

	def user_update_params
		ActionController::Parameters.new(JSON.parse(request.body.string)).permit(:username, :img_url, :first_name, :last_name)
	end
end
