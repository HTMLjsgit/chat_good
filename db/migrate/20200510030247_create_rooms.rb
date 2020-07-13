class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms, id: :string do |t|
      t.string :title
      t.integer :user_id
      t.text :body
      t.timestamps
    end
  end
end
