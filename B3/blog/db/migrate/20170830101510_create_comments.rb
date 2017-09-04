class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.string :content
      t.boolean :checked
      t.integer :article_id
      t.integer :admin_id
      
      t.references :article, foreign_key: true
      t.timestamps null: false
    end
  end
end
