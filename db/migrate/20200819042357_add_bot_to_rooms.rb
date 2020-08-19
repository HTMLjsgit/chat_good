class AddBotToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :bot, :boolean, default: false
  end
end
