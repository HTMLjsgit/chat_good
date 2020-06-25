class AddyoutubeIdToMessages < ActiveRecord::Migration[6.0]
  def change
  	add_column :messages, :youtube_id, :string, null: true
  end
end
