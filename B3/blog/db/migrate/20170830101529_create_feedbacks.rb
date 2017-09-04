class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :content
      t.boolean :checked
      t.references :user, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
