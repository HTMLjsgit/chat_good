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
    ng_word_params = ["ナイフ","死ね","しね", "4ね","氏ね","cね","ｃね","殺","市ね", "sine", "fack","fuck", "くそやろ" ,"クソ野郎","56す", "住所","刺す", "殺す", "殺してやる", "変態","野獣先輩", "キチガイ", "セクハラ", "ぶっ殺す", "ちんこ", "キス", "うんち", "うんこ", "ゴミ", "おっぱい", "まんこ", "性器", "せっくす", "SEX", "サル", "陰キャ", "カス", "かす", "ぶす", "ブス", "ぶ/す", "ぶっす", "ぶさいく", "ブサイク", "ぶっすう", "あの世", "血", "グロ", "ばばぁ","じじい", "婆", "爺","老害", "障害" ,"ちび", "チビ", "雑魚", "あほ", "アホ", "バカ", "馬鹿", "bs"] 
    ip = self.connection.ip_addr
    # puts "==========================" + current_user.name
    # user_signed_in? = self.connection.signed_in
    if data['message'].nil?
      return false
    end
    p "-------------------------" + data['message'].to_s
    p "--------------------------------------" + data['id']
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
    ng_word_params.each do |ng|
      if current_user.present?
        if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s, login: true, ng_word: true).exists?
          unless data['message'].nil?
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
