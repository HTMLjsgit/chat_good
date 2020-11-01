class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :room
	belongs_to :usermanager, optional: true

	after_update_commit { EditBroadcastJob.perform_later self }
	after_update_commit { EditAdminBroadcastJob.perform_later self }

	after_create_commit { MessageBroadcastJob.perform_later self}
	after_create_commit { MessageAdminBroadcastJob.perform_later self}
	validates :content, length: {maximum: 1000 }
	mount_uploader :file, FileUploader
	validate :file_size
	private

	def file_size
		# if file.size > .megabytes
			# errors.add(:file, "容量が大きすぎます。5MB未満のファイルにしてください。")
		# end
	end
end
