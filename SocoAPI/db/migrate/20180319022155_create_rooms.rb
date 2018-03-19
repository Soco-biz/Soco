class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :state
      t.string :local

      t.timestamps
    end
  end
end
