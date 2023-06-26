class AddMinesToMineBoard < ActiveRecord::Migration[7.0]
  def change
    add_column :mine_boards, :mines, :integer
  end
end
