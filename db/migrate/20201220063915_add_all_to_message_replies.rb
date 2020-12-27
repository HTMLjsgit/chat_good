class AddAllToMessageReplies < ActiveRecord::Migration[6.0]
  def change
    add_column :message_replies, :ip_id, :string
    add_column :message_replies, :login, :boolean
    add_column :message_replies, :url, :string
    add_column :message_replies, :usermanager_id, :integer
    add_column :message_replies, :username, :string
    add_column :message_replies, :youtube_id, :string
    add_column :message_replies, :file, :string
    add_column :message_replies, :message_id, :integer

  end
end
