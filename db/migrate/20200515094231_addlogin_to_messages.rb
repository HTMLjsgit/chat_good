class AddloginToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :login, :boolean, default: false
  end
end
