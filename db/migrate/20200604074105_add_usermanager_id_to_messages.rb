class AddUsermanagerIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :usermanager_id, :integer
  end
end
