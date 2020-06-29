class AddMessageReadingToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :message_reading, :boolean, default: false, null: false
  end
end
