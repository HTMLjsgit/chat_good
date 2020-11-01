class AddMessageImageToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :file, :string
  end
end
