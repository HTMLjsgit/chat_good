class AddloginToUsermanager < ActiveRecord::Migration[6.0]
  def change
  	add_column :usermanagers, :login, :boolean, default: false
  end
end
