class CreateUsermanagers < ActiveRecord::Migration[6.0]
  def change
    create_table :usermanagers do |t|
      t.integer :user_id, default: 0, null: false
      t.string :room_id, default: 0, null: false
      t.boolean :room_ban, default: false

      t.timestamps
    end
  end
end
