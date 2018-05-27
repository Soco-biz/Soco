class RemoveSocoTags < ActiveRecord::Migration[5.1]
  def change
    drop_table :soco_tags
  end
end
