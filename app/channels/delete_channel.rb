class DeleteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def delete(data)
  	ActionCable.server.broadcast 'delete_channel', id: data['id'], room_id: params['room'], current_user: current_user.id
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
  end
end
