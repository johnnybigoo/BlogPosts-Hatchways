class PostsController < ApplicationController
	def index
		puts params
		render json: { "success": true }, status: :ok

		tags = params[:tag] ? params[:tag].split(',') : []
		sortBy = params[:sortBy] ? params[:sortBy] : 'id'
		direction = params[:direction]

		validSortByList = ["id", "reads", "likes", "popularity"]
		validDirectionList = ["asc", "desc"]



		if tags.length < 1
			render json: { "error": "Tags parameter is required" }, status: 400
			return
		end

		if (!validSortByList.include?(sortBy) )
				render json: { "error": "sortBy parameter is invalid" }, status: 400
				return

		elsif (direction) && (!validDirectionList.include?(direction) )
				render json: { "error": "sortBy parameter is invalid" }, status: 400
				return
		end

		response = []

		for tag in tags do
				result = HTTParty.get( "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}")["posts"]
				response.push(result)
		end

		render json: { "posts": response.flatten(1).uniq}, status: 200
	end
end

