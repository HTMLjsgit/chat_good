class AddMesssageUrlToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :url, :string
  end
end
