class CreateMessageReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :message_replies do |t|
      t.text :content
      t.integer :against_user_id
      t.integer :user_id
      t.string :room_id
      
      t.timestamps
    end
  end
end
