require 'swagger_helper'
require 'minesweeper_service'

describe 'Minesweeper API' do
  path '/minesweeper' do
    post 'create minesweeper' do
      tags 'minesweeper'
      consumes 'application/json'

      parameter name: :minesweeper, in: :body, schema: {
        type: :object,
        properties: {
          rows: { type: :integer,  minimum: 8 },
          columns: { type: :integer,  minimum: 8 },
          mines: { type: :integer }
        },
        required: [ 'mines' ]
      }

      response '201', 'minesweeper created' do

        parameter type: :object,
               properties: {
                 board: { type: :array, },
                 id: { type: :string },
               },
               required: %w[board id]

        let(:minesweeper) { { rows: 12, columns: 10, mines: 15 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:minesweeper) { { rows: 3, columns: 2, mines: 2 } }
        run_test!
      end
    end
  end

  path '/minesweeper/{id}' do
    get 'get minesweeper' do
      tags 'minesweeper'
      consumes 'application/json'

      parameter name: :id, in: :path, schema: {
        type: :object,
        properties: {
          id: { type: :string}
        },
        required: [ 'id' ]
      }
      response '200', 'show minesweeper' do
        let(:minesweeper) { MinesweeperService.create_board({ rows: 9, columns:11, mines: 9 }) }
        let(:id){ minesweeper.id }
        run_test!
      end
    end
  end

  path '/minesweeper/{id}/flag_cell' do
    put 'put flag' do
      tags 'minesweeper flag'
      consumes 'application/json'

      parameter name: :id, in: :path, type: :string, required: true

      parameter name: :rows, in: :body, type: :integer, required: true

      parameter name: :column, in: :body, type: :integer, required: true

      response '200', 'add flag to a cell' do
        let(:minesweeper) { MinesweeperService.create_board({ rows: 9, columns:11, mines: 9 }) }
        let(:id){ minesweeper.id }
        let(:columns) { 3 }
        let(:rows) { 2 }

        run_test!
      end
    end

  end

end
