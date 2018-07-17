class CreateSocoPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :soco_posts, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.string :contents, null: false
      t.integer :reply
      t.integer :good, default: 0
      t.references :first_tag_id
      t.references :second_tag_id
      t.references :third_tag_id
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.text :image

      t.timestamps
    end
  end
end
