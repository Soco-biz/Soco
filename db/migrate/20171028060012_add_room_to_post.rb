class AddRoomToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :room, :text
  end
end
