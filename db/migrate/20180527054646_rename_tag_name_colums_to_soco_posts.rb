class RenameTagNameColumsToSocoPosts < ActiveRecord::Migration[5.1]
  def change
    rename_column :soco_posts, :first_tag_id_id, :first_tag_id
    rename_column :soco_posts, :second_tag_id_id, :second_tag_id
    rename_column :soco_posts, :third_tag_id_id, :third_tag_id
  end
end
