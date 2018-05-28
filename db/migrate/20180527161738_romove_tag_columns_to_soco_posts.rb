class RomoveTagColumnsToSocoPosts < ActiveRecord::Migration[5.1]
  def change
    remove_columns :soco_posts, :first_tag_id, :second_tag_id, :third_tag_id
  end
end
