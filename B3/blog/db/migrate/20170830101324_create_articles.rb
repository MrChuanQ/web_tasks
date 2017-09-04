class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      #t.boolean :checked
      t.integer :admin_id
      t.references :admin, foreign_key: true
      t.timestamps null: false
    end
  end
end
