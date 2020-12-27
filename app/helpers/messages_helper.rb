module MessagesHelper
	def message_url(url,file_go,room_id, id)
		file =  File.basename(url)
        perms = ['.jpg', '.jpeg', '.gif', '.png']
        perms2 = ['.mp4']
        perms3 = ['.mp3', '.wav']
		if perms.include?(File.extname(file).downcase)
			return image_tag url
		elsif perms2.include?(File.extname(file).downcase)
			return video_tag url,controls: true, class: "video_message"
		elsif perms3.include?(File.extname(file).downcase)
			return audio_tag url, controls: true
		else
			# ここにダウンロードリンクを作る

			return link_to "ダウンロード",message_file_download_path(room_id: room_id,id: id,url: file_go), remote: false, class: "link_download"
		end
	end
end
