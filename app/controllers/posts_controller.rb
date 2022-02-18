class PostsController < ApplicationController
	def index
		puts params
		render json: { "success": true }, status: :ok
	end
end

