class MineBoard < ApplicationRecord
  validates :board, presence: true
  validates :player_board, presence: true
  validates :status, presence: true
  validate  :validate_colum_size, :validate_row_size

  def validate_colum_size
    errors.add(:board,'colum number is minimum 8') if board.size < 8
  end

  def validate_row_size
    errors.add(:board,'row number is minimum 8') if board.first.size < 8
  end
end
