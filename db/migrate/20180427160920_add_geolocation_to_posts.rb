class AddGeolocationToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :latitude, :float, null: false
    add_column :posts, :longitude, :float, null: false
  end
end
