class AddMessagelimitToUsermanagers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :message_limit, :boolean, default: :false
  end
end
