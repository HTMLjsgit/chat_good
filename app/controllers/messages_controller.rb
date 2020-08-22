class MessagesController < ApplicationController
	def create
		image = params[:image]
		# room_id = params[:room_id]
		room_id = params[:room_id]
		content = params[:content]
		if image.blank? && room_id.blank? && content.blank?
			image = params[:message][:image]
			room_id = params[:message][:room_id]
			content = params[:message][:content]
		end

		# image = Base64.decode64(params[:image])
		# binding.pry
		# File.binwrite("public/uploads/message/image/draw/test2.png", image)
		unless request.os == "PlayStation Vita"
			if image.blank?
				return false
			end
		end

		if image.blank? && content.blank?
				return false
		end
		
		if user_signed_in?
			if Usermanager.where(room_id: room_id, user_id: current_user.id, login: true).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, user_id: current_user.id, login: true).exists?
				return false
			end
			@message = Message.new(image: image, room_id: room_id, ip_id: request.ip, user_id: current_user.id, username: current_user.name, login: true)
			image_from_base64(image, @message)
			
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
					image_from_base64(image, @message)

					flash =  "画像のアップロードに成功しました。 "
				else
					flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
				end
			end
			if request.os == "PlayStation Vita"
				if content.present?
				 message = Message.create!(content: content, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
				 flash[:image] = "メッセージの投稿に成功しました。"
				end
			end
		end

		@flash = flash
		@messages = Message.all

	end

	def update
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
				image_from_base64(image, @message)

				flash =  "画像のアップロードに成功しました。 "
			else
				flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
			end
			if request.os == "PlayStation Vita"
				message = Message.update(content: content, image: image, ip_id: request.ip)
				
				flash[:image] = "メッセージの投稿に成功しました。"
			end
		end

		@flash = flash
		@messages = Message.all
	end

	def image_from_base64(b64, message)
		# bin = Base64.decode64(b64)
		# file = Tempfile.new('public/uploads/message')
		# file.binmode
		# file << bin
		# file.rewind

		b = b64.delete("data:image/jpeg;base64,")
		File.open("#{Rails.root}/public/uploads/message/image/message-#{message.id}.png", "wb") {|f|
			f.write Base64.encode64(b)
			binding.pry

		}

	end
end
