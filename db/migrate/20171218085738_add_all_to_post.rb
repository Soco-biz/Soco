class AddAllToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :content, :text
    add_column :posts, :room, :text
    add_column :posts, :image, :text　similarity
    add_column :posts, :simvalue, :text
    add_column :posts, :latitude, :text
    add_column :posts, :longitude, :text
  end
end
