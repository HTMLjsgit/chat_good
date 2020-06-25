class CreatePasswordmanagers < ActiveRecord::Migration[6.0]
  def change
    create_table :passwordmanagers do |t|
      t.integer :user_id
      t.integer :room_id
      t.string :ip_id
      t.string :password

      t.timestamps
    end
  end
end
