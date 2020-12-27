class AddMessageEditRightToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :edit_right, :boolean, default: false, null: false
  end
end
