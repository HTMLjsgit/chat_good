class AddIpToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :ip_id, :string
  end
end
