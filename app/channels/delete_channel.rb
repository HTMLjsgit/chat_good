class DeleteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def delete(data)
  	ActionCable.server.broadcast 'delete_channel', id: data['id'], room_id: params['room']
  	if current_user.present?
  		message = Message.find_by(id: data['id'], room_id: params['room'], user_id: current_user.id)
  	end
  	# もしmessageに当てはまらなかったら強制的にはじき返す
  	if message.blank?
  		return false
  	end
    if message.present?
  	 message.destroy!
    end
  end
end
