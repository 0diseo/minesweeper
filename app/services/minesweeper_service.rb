# frozen_string_literal: true

module MinesweeperService
  DEFAULT_SIZE = 8

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
    board =  Array.new(params[:rows] || DEFAULT_SIZE).map{Array.new(params[:columns] || DEFAULT_SIZE, '0')}
    player_board =  Array.new(params[:rows] || DEFAULT_SIZE).map{Array.new(params[:columns] || DEFAULT_SIZE, '?')}
    mining_board(board, params[:mines])
    add_numbers(board)
    mine_board.create(status: :active, board: board, player_board: player_board)
  end

  def self.mining_board(board, mines)
    positions = (0..(board.size-1)).to_a.product((0..(board.first.size-1)).to_a)
    positions.shuffle.take(mines).each do |position|
      board[position[0]][position[1]] = 'mine'
    end
  end

  def self.add_numbers(board)
    (0..(board.size - 1)).each { |x|
      (0..(board.size - 1)).each { |y|
        count_near_mines(board, x, y) if board[x][y] != 'mine'
      }
    }
  end

  def self.count_near_mines(board, x, y)
    mines = 0
    mines += 1 if(x != 0 && board[x-1][y] == 'mine') #left
    mines += 1 if(x != 0 && y != 0 && board[x-1][y-1] == 'mine') #left, top corner
    mines += 1 if(y != 0 && board[x][y-1] == 'mine') #top
    mines += 1 if(x != (board.size - 1) && y != 0 && board[x+1][y-1] == 'mine') #top, right corner
    mines += 1 if(x != (board.size - 1) && board[x+1][y] == 'mine') #right
    mines += 1 if(x != (board.size - 1) && y != (board.first.size - 1) && board[x+1][y+1] == 'mine') #right, down corner
    mines += 1 if(y != (board.first.size - 1) && board[x][y+1] == 'mine') #down
    mines += 1 if(x != 0 && y != (board.first.size - 1) && board[x-1][y+1] == 'mine') #down , left corner
    board[x][y] = mines
  end

  def self.flag_cell(board, x, y)
    board.player_board[x][y] = 'flag'
    board.save
  end

  def self.undo_flag_cell(board, x, y)
    board.player_board[x][y] = '?'
    board.save
  end
end