class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :contents, null: false
      t.integer :good, default: 0
      t.integer :bad, default: 0

      t.timestamps
    end
  end
end
