class MessageReply < ApplicationRecord
	belongs_to :message
	belongs_to :room, optional: true
	belongs_to :user, optional: true
	mount_uploader :file, FileUploader
	after_create_commit { MessageReplyBroadcastJob.perform_later self}
	after_update_commit {EditReplyBroadcastJob.perform_later self}
end
