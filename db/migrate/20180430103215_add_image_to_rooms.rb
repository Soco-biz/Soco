class AddImageToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :image, :text
  end
end
