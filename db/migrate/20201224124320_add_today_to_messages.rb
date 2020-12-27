class AddTodayToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :today, :string
  end
end
