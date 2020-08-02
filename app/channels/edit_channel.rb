class EditChannel < ApplicationCable::Channel
  def subscribed
    if current_user.present?
      stream_from "edit_channel_#{params['room'].to_s}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def edit(data)
    if current_user.blank?
      return false
    end
  	ActionCable.server.broadcast 'edit_channel', id: data['id'].delete("message-"), room_id: params['room'], current_user: current_user.id
    ng_word = ENV['NG_WORD']
    ng_word2 = ng_word.split(',').map { |m| m.delete('[]"\\\\')}
    ng_word_params = ng_word2.map {|m| m.gsub(' ', "")}
    ip = self.connection.ip_addr
    # puts "==========================" + current_user.name
    # user_signed_in? = self.connection.signed_in
    if data['message'].nil?
      return false
    end
    now = Time.now
    secondsAgo = now - 10
    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists?
        return false
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists?
        return false
      end
    end
    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s, login: true, ng_word: true).exists?
        unless data['message'].nil?
          ng_word_params.each do |ng|
            if data['message'].include?(ng)
              return false
            end
          end
        end
      end
    end
    messagesCount = Message.where(ip_id: ip).where('created_at > ?', secondsAgo).count

    if data['message'].include?("https://www.youtube.com/watch?v=")
      urll = data['message'].gsub(/http.+v=/, "")
      url = urll.gsub(/&.+./, "")
    elsif data['message'].include?("https://youtu.be/")
      url = data['message'].gsub(/http.+be./, "")
    end
    if current_user.present?
  	  	message = Message.find_by(id: data['id'].delete("message-"), room_id: params['room'], user_id: current_user.id)
  	  	if message.blank?
          return false
        end
        if messagesCount <= 5
          message.update(content: data['message'], youtube_id: url, edit_right: true)
        end
  	else
      return false
    end


  end

end
