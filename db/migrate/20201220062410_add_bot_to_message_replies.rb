class AddBotToMessageReplies < ActiveRecord::Migration[6.0]
  def change
    add_column :message_replies, :bot, :boolean
  end
end
