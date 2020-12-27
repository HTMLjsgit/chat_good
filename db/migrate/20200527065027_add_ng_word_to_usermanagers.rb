class AddNgWordToUsermanagers < ActiveRecord::Migration[6.0]
  def change
    add_column :usermanagers, :ng_word, :boolean, default: false
  end
end
