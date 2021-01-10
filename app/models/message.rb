require('./app/service/create_notification.rb')
class Message < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :room
	belongs_to :usermanager, optional: true

	after_update_commit { EditBroadcastJob.perform_later self }
	after_update_commit { EditAdminBroadcastJob.perform_later self }

	after_create_commit { MessageBroadcastJob.perform_later self}
	after_create_commit { MessageAdminBroadcastJob.perform_later self}
	# after_create_commit {  }
	validates :content, length: {maximum: 1000 }
	mount_uploader :file, FileUploader
	validate :file_size
	has_many :notifications, dependent: :destroy
	has_many :message_replies, class_name: "MessageReply", foreign_key: "message_id"
	def create_message_notice(current_user)
		temp = Notification.where("visited_id = ? and visitor_id = ? and message_id = ? and action = ?", user_id, current_user.id, id, "message")
		if temp.blank?
			usermanagers = Usermanager.where(room_id: room_id)
			usermanagers.each do |user_manager|
			if user_manager.login
				if user_manager.message_notification
					
					notification = current_user.active_notifications.new(
						message_id: id,
						visited_id: user_manager.user_id,
						action: 'message'
					)
					if current_user.id != user_manager.user_id
						notification.save!
						if login
							if Rails.env.development?
								CreateNotification.call(
									contents: { 'en' => content, 'ja' => content},
									type: 'posts#create',
									headings: {'en' => "MessageCreatedBy#{current_user.name}",'ja' => "#{current_user.name}が新たなメッセージを送信しました。"},
									tags: [{'key': 'id','relation': '=',"value": "#{user_manager.user_id.to_s}"}],
									url: "localhost:3000"
								)
							else
								CreateNotification.call(
									contents: { 'en' => content, 'ja' => content},
									type: 'posts#create',
									headings: {'en' => "MessageCreatedBy#{current_user.name}",'ja' => "#{current_user.name}が新たなメッセージを送信しました。"},
									tags: [{'key': 'id','relation': '=',"value": "#{user_manager.user_id.to_s}"}],
									url: "https://good-chat.herokuapp.com"
								)
							end
						else
							if Rails.env.development?
								CreateNotification.call(
									contents: { 'en' => content, 'ja' => content},
									type: 'posts#create',
									headings: {'en' => "MessageCreatedBy#{current_user.name}",'ja' => "#{current_user.name}が新たなメッセージを送信しました。"},
									tags: [{'key': 'id','relation': '=',"value": "#{user_manager.user_id.to_s}"}],
									url: "localhost:3000"
								)
							else
								CreateNotification.call(
									contents: { 'en' => content, 'ja' => content},
									type: 'posts#create',
									headings: {'en' => "MessageCreatedBy#{current_user.name}",'ja' => "#{current_user.name}が新たなメッセージを送信しました。"},
									tags: [{'key': 'id','relation': '=',"value": "#{user_manager.user_id.to_s}"}],
									url: "https://good-chat.herokuapp.com"
								)
							end
						end
					end
				end
			end
		end
	end
end
	private

	def file_size
		if file.size > 10000.megabytes
			errors.add(:file, "容量が大きすぎます。5MB未満のファイルにしてください。")
		end
	end
end
