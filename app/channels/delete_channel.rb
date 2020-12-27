class DeleteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def delete(data)
    if current_user.nil?
      return false
    end
    if Message.find_by(id: data['id'], login: false).present?
  	 return false
    end
    if current_user.present?
  		message = Message.find_by(id: data['id'], room_id: params['room'], user_id: current_user.id, login: true)
  	end
  	# もしmessageに当てはまらなかったら強制的にはじき返す
    # binding.pry
  	if message.nil?
  		return false
  	end
    if message.present?
  	 message.destroy!
    end
    ActionCable.server.broadcast 'delete_channel', id: data['id'], room_id: params['room'], user_id: message.user_id, message_reply: false
  end

  def delete_reply(data)
  	if current_user.nil?
  		return false
  	end
  	if current_user.present?
  		if MessageReply.find_by(id: data['id'], login: false).present?
  			return false
  		end
  		message = MessageReply.find_by(id: data['id'], room_id: params['room'], user_id: current_user.id, login: true)
  		if message.nil?
  			return false
  		elsif message.present?
  			message.destroy!
  		end

  		ActionCable.server.broadcast "delete_channel", id: data['id'], room_id: params['room'], user_id: current_user.id, message_reply: true
  	end
  end
end
