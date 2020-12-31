class AddRoomGoToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :message_notification, :boolean, default: false
  end
end
