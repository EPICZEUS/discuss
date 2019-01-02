class Api::V1::Rooms::MessagesController < ApplicationController
	before_action :find_message, except: :create

	def create
		@message = Message.new(message_params)

		@message.room = Room.find(params[:room_id])

		if @message.save
			ActionCable.server.broadcast "room-#{@message.room.id}", {type: "message", message: @message}
			render json: {}
		else
			render json: {
				error: true,
				messages: @message.errors.full_messages
			}
		end
	end

	def show
		render json: @message
	end

	def update
		if @message.update(message_params)
			ActionCable.server.broadcast "room-#{@message.room.id}", {type: "messageEdit", content: @message.content, id: @message.id}
			render json: {}
		else
			render json: {
				error: true,
				messages: @message.errors.full_messages
			}
		end
	end

	def destroy
		byebug
		@message.destroy
	end

	private

	def find_message
		@message = Message.find(params[:id])
	end

	def message_params
		ActionController::Parameters.new(JSON.parse(request.body.string)).permit(:content, :room_id, :user_id)
	end
end
