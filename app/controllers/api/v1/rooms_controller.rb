class Api::V1::RoomsController < ApplicationController
	def index
		# byebug
		render json: Room.all
	end

	def create
		
	end

	def show
		@room = Room.find(params[:id])

		render json: @room
	end
end
