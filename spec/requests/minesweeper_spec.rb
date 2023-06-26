require 'rails_helper'

RSpec.describe "Minesweepers", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/minesweeper/create"
      expect(response).to have_http_status(:success)
    end
  end

end
