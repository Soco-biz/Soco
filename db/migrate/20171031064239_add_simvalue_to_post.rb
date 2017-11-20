class AddSimvalueToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :simvalue, :text
  end
end
