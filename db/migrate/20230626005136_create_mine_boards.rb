class CreateMineBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :mine_boards, id: :uuid do |t|
      t.string :status
      t.string :board, array: true, default: []
      t.string :player_board, array: true, default: []

      t.timestamps
    end
  end
end
