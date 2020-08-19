class AddbotToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :bot, :boolean, default: false
  end
end
