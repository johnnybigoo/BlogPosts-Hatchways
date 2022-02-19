require 'rails_helper'

RSpec.describe "Apis", type: :request do
  describe "GET /index" do
    it "ping" do
			get '/api/ping'

			result = JSON.parse(response.body)
			expect(result['success']).to eq(true)
    end
  end
end
