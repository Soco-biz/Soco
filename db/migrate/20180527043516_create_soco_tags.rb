class CreateSocoTags < ActiveRecord::Migration[5.1]
  def change
    create_table :soco_tags do |t|
      t.string :tag_name, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
