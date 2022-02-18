class ApiController < ApplicationController
	def ping
		render json: { "success": true }, status: :ok
	end
end