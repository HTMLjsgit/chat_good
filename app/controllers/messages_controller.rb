class MessagesController < ApplicationController
	def create

		image = params[:image]
		# room_id = params[:room_id]
		room_id = params[:room_id]
		content = params[:content]

		unless request.os == "PlayStation Vita"
			if image.nil?
				return false
			end
		end
		if image.nil?
			if content.nil?
				return false
			end
		end
		if user_signed_in?
			p "--ログイン---------------------------------------------"

			if Usermanager.where(room_id: room_id, user_id: current_user.id, login: true).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, user_id: current_user.id, login: true).exists?
				return false
			end
			@message = Message.new(image: image, room_id: room_id, ip_id: request.ip, user_id: current_user.id, username: current_user.name, login: true)
			if image.present?
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
			end
		else
			if Usermanager.where(room_id: room_id, ip_id: request.ip, login: false).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, ip_id: request.ip, login: false).exists?
				return false
			end
			if image.present?
				@message = Message.new(image: image, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
				if @message.save!
					flash =  "画像のアップロードに成功しました。 "
				else
					flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
				end
			end
			if request.os == "PlayStation Vita"
				if content.present?
				 Message.create!(content: content, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
				 flash[:image] = "メッセージの投稿に成功しました。"
				end
			end
		end

		@flash = flash
		@messages = Message.all

	end

	def update
		p "-------------------------------"
		image = params[:message][:image]
		room_id = params[:message][:room_id]
		content = params[:message][:content]
		if image.nil?
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
			@message.image = image
			@message.edit_right = true
			if @message.save
				 flash = "画像のアップロードに成功しました。"
			else
				 flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				Message.update(content: content, image: image, room_id: room_id, ip_id: request.op, user_id: current_user.id, username: current_user.name, login: true)
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
			@message.image = image
			@message.edit_right = true
			if @message.save	 
				flash =  "画像のアップロードに成功しました。 "
			else
				flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				Message.update(content: content, image: image, ip_id: request.ip)
				 flash[:image] = "メッセージの投稿に成功しました。"
			end
		end

		@flash = flash
		@messages = Message.all
	end
end
