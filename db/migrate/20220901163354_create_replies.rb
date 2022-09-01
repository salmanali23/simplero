class CreateReplies < ActiveRecord::Migration[7.0]
  def change
    create_table :replies do |t|
      t.text :content, null: false
      t.references :user
      t.references :comment

      t.timestamps
    end
  end
end
