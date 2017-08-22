class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.boolean :checked
      t.integer :admin_id
      t.integer :user_id
      t.timestamps
    end
  end
end
