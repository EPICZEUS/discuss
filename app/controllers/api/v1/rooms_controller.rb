class Api::V1::RoomsController < ApplicationController
	before_action :find_room, only: [:show, :destroy]

	def index
		render json: Room.all
	end

	def create
		@room = Room.create(name: params[:name])

		user = User.find(params[:owner_id])

		@room.users << user
		@room.owner = user

		@room.save

		if @room.valid?
			ActionCable.server.broadcast "list", type: "roomCreate", room: @room
			render json: @room
		else
			render json: {
				error: true,
				messages: @room.errors.full_messages
			}
		end
	end

	def show
		render json: @room
	end

	def destroy
		@room.destroy

		ActionCable.server.broadcast "room-#{params[:id]}", type: "roomDelete"
		ActionCable.server.broadcast "list", type: "roomDelete", id: params[:id]
	end

	private
	def find_room
		@room = Room.find(params[:id])
	end
end
