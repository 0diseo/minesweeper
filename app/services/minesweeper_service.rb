# frozen_string_literal: true

module MinesweeperService

  def self.mine_board
    @mine_board ||= MineBoardAdapter.new
  end

  def self.mine_board=(board)
    @mine_board ||= board
  end

  def self.find(id)
    mine_board.find(id)
  end

  def self.create_board(params)
    board =  Array.new(params[:rows].to_i).map{Array.new(params[:columns].to_i, '0')}
    player_board =  Array.new(params[:rows].to_i).map{Array.new(params[:columns].to_i, '?')}
    mining_board(board, params[:mines].to_i)
    add_numbers(board)
    mine_board.create(status: :active, board: board, player_board: player_board, mines: params[:mines])
  end

  def self.flag_cell(board, x, y)
    board.player_board[y][x] = 'flag'
    board.save
  end

  def self.undo_flag_cell(board, x, y)
    board.player_board[y][x] = '?'
    board.save
  end

  def self.select_cell(board, x, y)
    board.player_board[y][x] =  board.board[y][x]
    open_around_cell_if_cero(board, x, y)
    board.status = 'game over' if board.player_board[y][x] == 'mine'
    board.status = 'win' if board.player_board.map{|row| row.count{|cell| cell == 'flag' || cell == '?' }}.sum == board.mines
    board.save
  end

  private
  def self.count_near_mines(board, x, y)
    mines = 0
    mines += 1 if(x != 0 && board[y][x-1] == 'mine') #left
    mines += 1 if(x != 0 && y != 0 && board[y-1][x-1] == 'mine') #left, top corner
    mines += 1 if(y != 0 && board[y-1][x] == 'mine') #top
    mines += 1 if(x != (board.first.size - 1) && y != 0 && board[y-1][x+1] == 'mine') #top, right corner
    mines += 1 if(x != (board.first.size - 1) && board[y][x+1] == 'mine') #right
    mines += 1 if(x != (board.first.size - 1) && y != (board.size - 1) && board[y+1][x+1] == 'mine') #right, down corner
    mines += 1 if(y != (board.size - 1) && board[y+1][x] == 'mine') #down
    mines += 1 if(x != 0 && y != (board.size - 1) && board[y+1][x-1] == 'mine') #down , left corner
    board[y][x] = mines
  end

  def self.open_around_cell_if_cero(board, x, y)
    if board.board[y][x]  == '0'
      select_cell(board, x-1, y) if(x != 0 && board.player_board[y][x-1] == '?') #left
      select_cell(board, x-1, y-1) if(x != 0 && y != 0 && board.player_board[y-1][x-1] == '?') #left, top corner
      select_cell(board, x, y-1) if(y != 0 && board.player_board[y-1][x] == '?') #top
      select_cell(board, x+1, y-1) if(x != (board.player_board.first.size - 1) && y != 0 && board.player_board[y-1][x+1] == '?') #top, right corner
      select_cell(board, x+1, y) if(x != (board.player_board.first.size - 1) && board.player_board[y][x+1] == '?') #right
      select_cell(board, x+1, y+1) if(x != (board.player_board.first.size - 1) && y != (board.player_board.size - 1) && board.player_board[y+1][x+1] == '?') #right, down corner
      select_cell(board, x, y+1) if(y != (board.player_board.size - 1) && board.player_board[y+1][x] == '?') #down
      select_cell(board, x-1, y+1) if(x != 0 && y != (board.player_board.size - 1) && board.player_board[y+1][x-1] == '?') #down , left corner
    end
  end

  def self.mining_board(board, mines)
    positions = (0..(board.size-1)).to_a.product((0..(board.first.size-1)).to_a)
    positions.shuffle.take(mines).each do |position|
      board[position[0]][position[1]] = 'mine'
    end
  end

  def self.add_numbers(board)
    (0..(board.size - 1)).each { |y|
      (0..(board.first.size - 1)).each { |x|
        count_near_mines(board, x, y) if board[y][x] != 'mine'
      }
    }
  end
end