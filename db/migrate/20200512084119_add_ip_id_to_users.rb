class AddIpIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :ip_id, :string
  end
end
