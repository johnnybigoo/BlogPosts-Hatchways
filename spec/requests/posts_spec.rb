require 'rails_helper'

RSpec.describe "Posts", type: :request do
	describe 'GET /api/posts with invalid params' do
    before { get '/api/posts' }

    it 'should return status code 400' do
      expect(response).to have_http_status(400)
    end

    before { get '/api/posts', params: { tags: '' } }

    it 'should return status code 400 if tags is blank' do
      expect(response).to have_http_status(400)
    end

    context 'when sortBy is invalid' do
      before { get '/api/posts', params: { tags: 'science', sortBy: 'name' } }

      it 'should fail if sortBy is invalid' do
        expect(response).to have_http_status(400)

        expect(json['error']).to eq('sortBy parameter is invalid')
      end
    end

    context 'when direction is invalid' do
      before { get '/api/posts', params: { tags: 'science', direction: 'up' } }
      it 'should fail if direction is invalid' do
        expect(response).to have_http_status(400)

        expect(json['error']).to eq('direction parameter is invalid')
      end
    end
  end

  describe 'GET /api/posts with valid params' do
    context 'when tags is valid' do

      it 'should return status code 200' do
					VCR.use_cassette("posts_valid_params_history") do
						get '/api/posts', params: { tags: 'history' }
						expect(response).to have_http_status(200)
					end
      end


      it 'should return status code 200' do
				VCR.use_cassette("posts_valid_params_history_tech") do
					get '/api/posts', params: { tags: 'history,tech' }
					expect(response).to have_http_status(200)
				end
      end

      it 'should have valid posts' do
				VCR.use_cassette("posts_valid_params_history_tech") do
					get '/api/posts', params: { tags: 'history,tech' }
					expect(json['posts']).not_to be_empty
					values = values_from_json('id')
					expect(values).to eq(values.sort)
				end
      end

      it 'should have required keys in response' do
				VCR.use_cassette("posts_valid_params_history_tech") do
					get '/api/posts', params: { tags: 'history,tech' }
					expect(json['posts'][0].keys).to contain_exactly('author', 'authorId', 'id',
																													'likes', 'popularity', 'reads', 'tags')
				end
      end
    end

    context 'when sortBy have the param reads' do

      it 'should pass if sortBy is valid' do
				VCR.use_cassette("sortby_with_valid_params") do
					get '/api/posts', params: { tags: 'history,tech', sortBy: 'reads' }
					expect(json['posts']).not_to be_empty
					values = values_from_json('reads')
					expect(values).to eq(values.sort)
				end
      end
    end

    context 'when sortBy have the param likes' do

      it 'should pass if sortBy is valid' do
				VCR.use_cassette("sortby_with_valid_params") do
					get '/api/posts', params: { tags: 'history,tech', sortBy: 'likes' }
					expect(json['posts']).not_to be_empty
					values = values_from_json('likes')
					expect(values).to eq(values.sort)
				end
      end
    end

		context 'when sortBy have the param popularity' do

      it 'should pass if sortBy is valid' do
				VCR.use_cassette("sortby_with_valid_params") do
					get '/api/posts', params: { tags: 'history,tech', sortBy: 'popularity' }
					expect(json['posts']).not_to be_empty
					values = values_from_json('popularity')
					expect(values).to eq(values.sort)
				end
      end
    end

    context 'when direction is valid' do

      it 'should return a list of post reversed' do
				VCR.use_cassette("direction_with_valid_params") do
					get '/api/posts', params: { tags: 'history,tech', sortBy: 'popularity', direction: 'desc' }
					values = values_from_json('popularity')
					expect(values).to eq(values.sort.reverse)
				end
      end
    end
  end
end
