require 'minesweeper_service'
class MinesweeperController < ApplicationController
  before_action :set_board, only: %i[ show flag_cell undo_flag_cell]
  before_action :validate_row_and_colum, only: %i[flag_cell undo_flag_cell]

  def create
    @board = MinesweeperService.create_board(minesweeper_params)
    if @board.valid?
      render json: { board: @board.player_board, id: @board.id }
    else
      render json: @board.errors, status: 422
    end
  end

  def show
    render json: { board: @board.player_board, id: @board.id }
  end

  def flag_cell
    MinesweeperService.flag_cell(@board, params[:row], params[:column] )
    render json: { board: @board.player_board, id: @board.id }
  end

  def undo_flag_cell
    MinesweeperService.undo_flag_cell(@board, params[:row], params[:column] ) if @board.player_board[params[:row]][params[:column]] == 'flag'
    render json: { board: @board.player_board, id: @board.id }
  end

  private
  def minesweeper_params
    params.require(:minesweeper_params).permit(:rows, :columns, :mines)
  end

  def set_board
    @board = MinesweeperService.find(params[:id])
    render json: { error: "id board not valid"}, status: 422 unless @board
  end

  def validate_row_and_colum
    render json: {error: "row or column is out of range"}, status: 422 unless( params[:column] < @board.player_board.size && params[:row] < @board.player_board.first.size )
  end

end
