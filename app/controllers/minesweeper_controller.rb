require 'minesweeper_service'
class MinesweeperController < ApplicationController
  def create
    @board = MinesweeperService.create_board(minesweeper_params)
    if @board.valid?
      render json: { board: @board.player_board, id: @board.id }
    else
      render json: @board.errors, status: 422
    end
  end

  def show
    @board = MinesweeperService.find(params[:id])
    render json: { board: @board.player_board, id: @board.id }
  end

  private
  def minesweeper_params
    params.require(:minesweeper_params).permit(:rows, :columns, :mines)
  end
end
