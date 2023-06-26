class MineBoard < ApplicationRecord
  validates :board, presence: true
  validates :player_board, presence: true
  validates :status, presence: true
  before_save :validate_colum_size, :validate_row_size

  def validate_colum_size
    raise ArgumentError, 'colum number is minimum 8' if board.size < 8
  end

  def validate_row_size
    raise ArgumentError, 'row number is minimum 8' if board.first.size < 8
  end
end
