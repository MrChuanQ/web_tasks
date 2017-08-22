class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.string :content
      t.boolean :checked
      t.integer :article_id
      t.integer :user_id
      t.integer :admin_id
      t.timestamps
    end
  end
end
