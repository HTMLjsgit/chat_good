class AddDrawNameToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :image_draw, :boolean, default: false
  end
end
