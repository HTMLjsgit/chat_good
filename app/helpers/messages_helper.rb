module MessagesHelper
	def message_url(url, id)
		url.gsub("/uploads/message/#{id}/", "")
	end
end
