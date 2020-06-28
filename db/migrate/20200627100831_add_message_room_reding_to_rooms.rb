class AddMessageRoomRedingToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :reading, :boolean, default: false
  end
end
