class AddEditRightToMessageReplies < ActiveRecord::Migration[6.0]
  def change
    add_column :message_replies, :edit_right, :boolean
  end
end
