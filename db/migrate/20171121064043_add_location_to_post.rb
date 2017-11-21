class AddLocationToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :latitude, :text
    add_column :posts, :longitude, :text
  end
end
