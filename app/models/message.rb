class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :room
	belongs_to :usermanager, optional: true

	after_update_commit { EditBroadcastJob.perform_later self }
	after_update_commit { EditAdminBroadcastJob.perform_later self }
	# after_create_commit { MessageAdminBroadcastJob.perform_later self}

	after_create_commit { MessageBroadcastJob.perform_later self}
	after_create_commit { MessageAdminBroadcastJob.perform_later self}
	# after_update_commit { EditBroadcastJob.perform_later self }
	# has_rich_text :content
	validates :content, length: {maximum: 1000 }
	mount_uploader :image, ImageUploader
	validate :image_size
	private

	def image_size
		if image.size > 5.megabytes
			errors.add(:image, "容量が大きすぎます。5MB未満のファイルにしてください。")
		end
	end
end
