class AddRoomIdToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :rooms, foreign_key: true
  end
end
