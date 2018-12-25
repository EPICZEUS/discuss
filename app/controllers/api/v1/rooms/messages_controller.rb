class Api::V1::Rooms::MessagesController < ApplicationController
	before_action :find_message

	def show
		render json: @message
	end

	def update
		if @message.update(message_params)
			render json: @message
		end
	end

	def destroy
		@message.destroy
	end

	private

	def find_message
		@message = Message.find(params[:id])
	end

	def message_params
		ActionController::Parameters.new(JSON.parse(request.body.string)).permit(:content)
	end
end
