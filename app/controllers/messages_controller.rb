class MessagesController < ApplicationController
	require "fileutils"

	def create
		image_draw = false
		image = params[:image]
		# room_id = params[:room_id]
		room_id = params[:room_id]
		content = params[:content]
		draw_picture = params[:draw_picture]
		if image.blank? && room_id.blank? && content.blank?
			image = params[:message][:image]
			room_id = params[:message][:room_id]
			content = params[:message][:content]
		end
		# image = Base64.decode64(params[:image])
		# File.binwrite("public/uploads/message/image/draw/test2.png", image)
		unless request.os == "PlayStation Vita"
			if draw_picture.blank?
				if image.blank?
					return false
				end
			end
		end
		if draw_picture.blank?
			if image.blank? && content.blank?
					return false
			end
		end
		if user_signed_in?
			if Usermanager.where(room_id: room_id, user_id: current_user.id, login: true).empty?
				return false
			end
			if Usermanager.where(room_id: room_id, room_ban: true, user_id: current_user.id, login: true).exists?
				return false
			end
			@message = Message.new(image: image, room_id: room_id, ip_id: request.ip, user_id: current_user.id, username: current_user.name, login: true)
			if draw_picture.present?
				image_draw = true
			end

			@message.image_draw = image_draw
			# if image.include?("data:image/jpeg;base64,")
			# 	@message.image_draw = true
			# end
			if image.present? || draw_picture.present?
				if @message.save!
					if draw_picture.present?
						image_go = image_from_base64(draw_picture, @message)
					end

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
			@message = Message.new(image: image, room_id: room_id, ip_id: request.ip, username: "名無し", login: false)
			if draw_picture.present?
				image_draw = true
			end
			@message.image_draw = image_draw

			if image.present? || draw_picture.present?
				if @message.save!
					if draw_picture.present?
						image_go = image_from_base64(draw_picture, @message)
					end
					flash =  "画像のアップロードに成功しました。 "
				else
					flash = "画像のアップロードに失敗しました。 画像の容量は5MB未満にしてください。"
				end
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

	def image_from_base64(image, message)
		file = image.gsub('data:image/jpeg;base64,','')
		plain = Base64.decode64(file)
		name = 'message-' + message.id.to_s
		file_name = "#{name}.jpeg"
		unless Dir.exists? "public/uploads/#{message.class.to_s.underscore}"
			Dir.mkdir("public/uploads/#{message.class.to_s.underscore}")
		end
		if  Dir.exists? "public/uploads/#{message.class.to_s.underscore}"
			Dir.mkdir("public/uploads/#{message.class.to_s.underscore}/#{message.id}")
			File.open("public/uploads/#{message.class.to_s.underscore}/#{message.id}/#{file_name}", 'wb') { |f| f.write(plain)}
		end
	end
end