class MessagesController < ApplicationController

	def create
		file = params[:file]
		# room_id = params[:room_id]
		room_id = params[:room_id]
		content = params[:content]
		if file.blank? && room_id.blank? && content.blank?
			file = params[:message][:file]
			room_id = params[:message][:room_id]
			content = params[:message][:content]
		end
		# image = Base64.decode64(params[:image])
		# File.binwrite("public/uploads/message/image/draw/test2.png", image)
		unless request.os == "PlayStation Vita"
			if file.blank?
				return false
			end
		end
		if file.blank? && content.blank?
				return false
		end
		if user_signed_in?
			if Usermanager.where(room_id: room_id, user_id: current_user.id, login: true).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, user_id: current_user.id, login: true).exists?
				return false
			end
			@message = Message.new(file: file, room_id: room_id, ip_id: request.ip, user_id: current_user.id, username: current_user.name, login: true)

			# if image.include?("data:image/jpeg;base64,")
			# 	@message.image_draw = true
			# end
			if @message.save!
			   flash = "画像のアップロードに成功しました。"
			else
			   flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				if content.present?
					Message.create!(content: content, room_id: room_id, ip_id: request.op, user_id: current_user.id, username: current_user.name, login: true)
					flash = "メッセージの投稿に成功しました。"
				end
			end
		else
			if Usermanager.where(room_id: room_id, ip_id: request.ip, login: false).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, ip_id: request.ip, login: false).exists?
				return false
			end
			@message = Message.new(file: file, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
			if @message.save!
				flash =  "画像のアップロードに成功しました。 "
			else
				flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				if content.present?
				   message = Message.create!(content: content, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
				   flash = "メッセージの投稿に成功しました。"
				end
			end
		end
		@flash = flash
		@messages = Message.all
	end

	def update
		file = params[:message][:file]
		room_id = params[:message][:room_id]
		content = params[:message][:content]
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
			@message = Message.find_by(id: params[:id], room_id: room_id)

			@message.file = file
			@message.edit_right = true
			if @message.save
				 flash = "画像のアップロードに成功しました。"
			else
				 flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				Message.update(content: content, file: file, room_id: room_id, ip_id: request.op, user_id: current_user.id, username: current_user.name, login: true)
				flash = "メッセージの投稿に成功しました。"
			end
		else
			if Usermanager.where(room_id: room_id, ip_id: request.ip, login: false).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, ip_id: request.ip, login: false).exists?
				return false
			end
			@message = Message.find_by(id: params[:id], room_id: room_id)
			@message.file = file
			@message.edit_right = true
			if @message.save
				flash =  "画像のアップロードに成功しました。 "
			else
				flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				message = Message.update(content: content, file: file, ip_id: request.ip)
				
				flash[:file] = "メッセージの投稿に成功しました。"
			end
		end
		@flash = flash
		@messages = Message.all
	end

	def download
		url = params[:url]
		id = params[:id]
		message = Message.find params[:id]
		send_file "public/uploads/message/file/#{id}/#{url}"
	end
end