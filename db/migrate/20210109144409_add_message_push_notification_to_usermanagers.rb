class AddMessagePushNotificationToUsermanagers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :message_push_notification, :boolean
  end
end
