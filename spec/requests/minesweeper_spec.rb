require 'rails_helper'

RSpec.describe "Minesweepers", type: :request do
  describe "POSTS /create" do
    describe "with valid parameters" do
      let(:valid_params){ { "minesweeper": {"rows": 10, "columns": 12, "mines": 25 } } }
      it "returns http success" do
        post "/minesweeper", params: valid_params
        expect(response).to have_http_status(:success)
      end

      it 'creates a new tweet' do
        expect {
          post "/minesweeper", params: valid_params
        }.to change(MineBoard, :count).by(1)
      end
    end

    describe "with not valid parameters" do
      let(:invalid_params){ { "minesweeper": {"rows": 3, "columns":2, "mines": 25 } } }

      it "returns http Unprocessable Entity" do
        post "/minesweeper", params: invalid_params
        expect(response).to have_http_status(422)
      end

      it "returns http Unprocessable Entity errors" do
        post "/minesweeper", params: invalid_params
        expect(JSON.parse(response.body)["board"]).to eq(["colum number is minimum 8", "row number is minimum 8"])
      end

      it 'not creates a new MineBoard' do
        expect {
          post "/minesweeper", params: invalid_params
        }.not_to change(MineBoard, :count)
      end
    end
  end

  describe "GET /show" do
    describe "with valid parameters" do
      let(:board) { Array.new(8).map{Array.new(8, '0')}  }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: board)}

      it "returns http success" do
        get "/minesweeper/#{mine_board.id}"
        expect(response).to have_http_status(:success)
      end

      it "returns board and id" do
        get "/minesweeper/#{mine_board.id}"
        expect(response.body).to eq({"board": mine_board.player_board, "id": mine_board.id}.to_json)
      end
    end
  end

  describe "PUT /:id/flag_cell" do
    describe "with valid parameters" do
      let(:board) { Array.new(8).map{Array.new(8, '0')}  }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: board)}
      let(:valid_params) { { row:3, column:2} }

      it "returns http success" do
        put "/minesweeper/#{mine_board.id}/flag_cell", params: valid_params
        expect(response).to have_http_status(:success)
      end

      it "returns http success" do
        put "/minesweeper/#{mine_board.id}/flag_cell", params: valid_params
        expect(JSON.parse(response.body)["board"][3][2]).to eq('flag')
      end
    end

    describe "with invalid parameters" do
      let(:board) { Array.new(8).map{Array.new(8, '0')}  }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: board)}
      let(:game_over_board) {MineBoard.create(status: 'game over', board: board, player_board: board)}
      let(:invalid_params) { { row:30, column:-2} }

      it "returns id board not valid" do
        put "/minesweeper/56464654efsd/flag_cell", params: invalid_params
        expect(JSON.parse(response.body)).to eq({"error"=>"id board not valid"})
      end

      it "returns row or column is out of range" do
        put "/minesweeper/#{mine_board.id}/flag_cell", params: invalid_params
        expect(JSON.parse(response.body)).to eq({"error"=>"row or column is out of range"})
      end

      it "returns the game is over" do
        put "/minesweeper/#{game_over_board.id}/flag_cell", params: { row: 3, column: 3}
        expect(JSON.parse(response.body)["error"]).to eq("the game is over")
      end
    end
  end

  describe "PUT /:id/undo_flag_cell" do
    describe "with valid parameters" do
      let(:board) { Array.new(8).map{Array.new(8, '0')}  }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: board)}
      let(:valid_params) { { row:3, column:2} }

      before do
        board[2][3] = 'flag'
      end

      it "returns http success" do
        put "/minesweeper/#{mine_board.id}/undo_flag_cell", params: valid_params
        expect(response).to have_http_status(:success)
      end

      it "returns http success" do
        put "/minesweeper/#{mine_board.id}/undo_flag_cell", params: valid_params
        expect(JSON.parse(response.body)["board"][2][3]).to eq('flag')
      end
    end

    describe "with invalid parameters" do
      let(:board) { Array.new(8).map{Array.new(8, '0')}  }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: board)}
      let(:game_over_board) {MineBoard.create(status: 'game over', board: board, player_board: board)}
      let(:invalid_params) { { row:30, column:-2} }

      it "returns id board not valid" do
        put "/minesweeper/56464654efsd/undo_flag_cell", params: invalid_params
        expect(JSON.parse(response.body)).to eq({"error"=>"id board not valid"})
      end

      it "returns row or column is out of range" do
        put "/minesweeper/#{mine_board.id}/undo_flag_cell", params: invalid_params
        expect(JSON.parse(response.body)).to eq({"error"=>"row or column is out of range"})
      end

      it "returns the game is over" do
        put "/minesweeper/#{game_over_board.id}/undo_flag_cell", params: { row: 3, column: 3}
        expect(JSON.parse(response.body)["error"]).to eq("the game is over")
      end
    end
  end

  describe "PUT /:id/select_cell" do
    describe "with valid parameters" do
      let(:player_board) { Array.new(8).map{Array.new(8, '?')}  }
      let(:board) { [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,1,1,1,1,1,1,0],
        [0,1,'mine',1,1,'mine',2,1],
        [1,2,1,1,2,2,3,'mine'],
        ['mine',1,0,0,1,'mine',2,1],
        [2,2,0,0,1,1,1,0],
        ['mine',1,0,0,0,0,0,0]
      ] }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: player_board)}
      let(:valid_params) { { row:1, column:4} }

      it "returns http success" do
        put "/minesweeper/#{mine_board.id}/undo_flag_cell", params: valid_params
        expect(response).to have_http_status(:success)
      end

      it "returns board with cell open" do
        put "/minesweeper/#{mine_board.id}/select_cell", params: valid_params
        expect(JSON.parse(response.body)["board"][1][4]).to eq('0')
      end

      it "open 0 and around cells" do
        put "/minesweeper/#{mine_board.id}/select_cell", params: valid_params
        expect(JSON.parse(response.body)["board"]).to eq([%w[0 0 0 0 0 0 0 0],
                                                          %w[0 0 0 0 0 0 0 0],
                                                          %w[0 1 1 1 1 1 1 0],
                                                          %w[0 1 ? ? ? ? 2 1],
                                                          %w[1 2 ? ? ? ? ? ?],
                                                          %w[? ? ? ? ? ? ? ?],
                                                          %w[? ? ? ? ? ? ? ?],
                                                          %w[? ? ? ? ? ? ? ?]])
      end



    end

    describe "end the game with a mine" do
      let(:player_board) { Array.new(8).map{Array.new(8, '?')}  }
      let(:board) { [
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,1,1,1,1,1,1,0],
        [0,1,'mine',1,1,'mine',2,1],
        [1,2,1,1,2,2,3,'mine'],
        ['mine',1,0,0,1,'mine',2,1],
        [2,2,0,0,1,1,1,0],
        ['mine',1,0,0,0,0,0,0]
      ] }
      let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: player_board)}


      it "returns board with mine open" do
        put "/minesweeper/#{mine_board.id}/select_cell", params: { row:3, column:2}
        expect(JSON.parse(response.body)["board"][3][2]).to eq('mine')
      end

      it "returns status game over " do
        put "/minesweeper/#{mine_board.id}/select_cell", params: { row:3, column:2}
        expect(JSON.parse(response.body)["status"]).to eq('game over')
      end
    end
  end

  describe "end the game wining" do
    let(:player_board) { [
      [0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0],
      [0,1,1,1,1,1,1,0],
      [0,1,'?',1,1,'?',2,1],
      ['?',2,1,1,2,2,3,'?'],
      ['?',1,0,0,1,'?',2,1],
      [2,2,0,0,1,1,1,0],
      ['?',1,0,0,0,0,0,0]
    ]  }

    let(:board) { [
      [0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0],
      [0,1,1,1,1,1,1,0],
      [0,1,'mine',1,1,'mine',2,1],
      [1,2,1,1,2,2,3,'mine'],
      ['mine',1,0,0,1,'mine',2,1],
      [2,2,0,0,1,1,1,0],
      ['mine',1,0,0,0,0,0,0]
    ] }
    let(:mine_board) {MineBoard.create(status: 'active', board: board, player_board: player_board, mines: 6)}

    it "returns status win " do
      put "/minesweeper/#{mine_board.id}/select_cell", params: { row:4, column:0}
      expect(JSON.parse(response.body)["status"]).to eq('win')
    end
  end
end
