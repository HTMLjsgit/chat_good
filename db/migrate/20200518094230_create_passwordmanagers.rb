class CreatePasswordmanagers < ActiveRecord::Migration[6.0]
  def change
    create_table :passwordmanagers do |t|
      t.integer :user_id
      t.string :room_id
      t.string :ip_id
      t.string :password

      t.timestamps
    end
  end
end
