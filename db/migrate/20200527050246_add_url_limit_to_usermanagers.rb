class AddUrlLimitToUsermanagers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :url_limit, :boolean, default: false
  end
end
