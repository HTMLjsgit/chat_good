class AddUsermanagerGoToUsermanagers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :message_notification, :boolean, default: false
  end
end
