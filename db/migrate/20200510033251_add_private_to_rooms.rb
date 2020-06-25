class AddPrivateToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :public, :boolean, default: false
  end
end
