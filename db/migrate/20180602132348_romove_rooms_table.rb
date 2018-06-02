class RomoveRoomsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :rooms
  end
end
