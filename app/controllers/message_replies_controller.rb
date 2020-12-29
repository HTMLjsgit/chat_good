class MessageRepliesController < ApplicationController
	before_action :authenticate_user!
	def create
		file = params[:message_reply][:file]
		message_id = params[:message_reply][:message_id]
		room_id = params[:message_reply][:room_id]
		@reply = MessageReply.new(file: file, message_id: message_id, room_id: room_id)
		@reply.user_id = current_user.id
		@reply.save!
		render 'create.js.erb'
	end
	def update
		file = params[:message_reply][:file]
		room_id = params[:message_reply][:room_id]
		content = params[:message_reply][:content]
		if file.nil?
			return false
		end
		if user_signed_in?
			if Usermanager.where(room_id: room_id, user_id: current_user.id, login: true).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, user_id: current_user.id, login: true).exists?
				return false
			end
			@message = MessageReply.find_by(id: params[:id], room_id: room_id)

			@message.file = file
			@message.edit_right = true
			if @message.save
				 flash = "画像のアップロードに成功しました。"
			else
				 flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
		else
			if Usermanager.where(room_id: room_id, ip_id: request.ip, login: false).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, ip_id: request.ip, login: false).exists?
				return false
			end
			@message = MessageReply.find_by(id: params[:id], room_id: room_id)
			@message.file = file
			@message.edit_right = true
			if @message.save
				flash =  "画像のアップロードに成功しました。 "
			else
				flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
		end
		@flash = flash
		@messages = MessageReply.all
	end

	def download
		url = params[:url]
		id = params[:id]
		send_file "public/uploads/message_reply/file/#{id}/#{url}"
	end
	private

	def create_params
		params.require(:message_reply).permit(:file, :message_id, :room_id)
	end
end
