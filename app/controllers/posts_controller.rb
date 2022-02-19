class PostsController < ApplicationController
	def index
		tags = params[:tags] ? params[:tags].split(',') : []
		sort_by = params[:sortBy] ? params[:sortBy] : 'id'
		direction = params[:direction] ? params[:direction] : 'asc'

		sort_by_list = ["id", "reads", "likes", "popularity"]
		direction_list = ["asc", "desc"]



		if tags.length < 1
			render json: { "error": "Tags parameter is required" }, status: 400
			return
		end

		if !sort_by_list.include?(sort_by)
				render json: { "error": "sortBy parameter is invalid" }, status: 400
				return
		end

		if !direction_list.include?(direction)
				render json: { "error": "sortBy parameter is invalid" }, status: 400
				return
		end

		posts = []

		for tag in tags do
				result = HTTParty.get( "https://api.hatchways.io/assessment/blog/posts?tag=#{tag}")
				posts.push(result["posts"])
		end

		posts = posts.flatten.sort { |a,b| a[sort_by.to_s] <=> b[sort_by.to_s] }
		posts = posts.reverse if direction == 'desc'

		render json: { "posts": posts.uniq }, status: 200
	end
end

