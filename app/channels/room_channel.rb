class RoomChannel < ApplicationCable::Channel

  def subscribed
    ip = self.connection.ip_addr
    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists? || Usermanager.where(user_id: current_user.id, login: true, room_id: params['room']).empty?
        stream_from "room_channel_nil"
      else
        stream_from "room_channel_#{params['room'].to_s}"
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists? || Usermanager.where(ip_id: ip, login: false, room_id: params['room']).empty?
        stream_from "room_channel_nil"
      else
        stream_from "room_channel_#{params['room'].to_s}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    if current_user.present?
      ActionCable.server.broadcast 'room_channel', room_id: params['room'].to_s, current_user: current_user.id
   	else
      ActionCable.server.broadcast 'room_channel', room_id: params['room'].to_s, current_user: nil

    end
    # NGワード集
    ng_word_params = ["ナイフ","死ね","しね", "4ね","氏ね","cね","ｃね","殺","市ね", "sine", "fack","fuck", "くそやろ" ,"クソ野郎","56す", "住所","刺す", "殺す", "殺してやる", "変態","野獣先輩", "キチガイ", "セクハラ", "ぶっ殺す", "ちんこ", "キス", "うんち", "うんこ", "ゴミ", "おっぱい", "まんこ", "性器", "せっくす", "SEX", "サル", "陰キャ", "カス", "かす", "ぶす", "ブス", "ぶ/す", "ぶっす", "ぶさいく", "ブサイク", "ぶっすう", "あの世", "血", "グロ", "ばばぁ","じじい", "婆", "爺","老害", "障害" ,"ちび", "チビ", "雑魚", "あほ", "アホ", "バカ", "馬鹿", "bs"] 
    ip = self.connection.ip_addr
    # puts "==========================" + current_user.name
    # user_signed_in? = self.connection.signed_in
    now = Time.now
    secondsAgo = now - 10

    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists?
        return false
      end
      if Usermanager.where(user_id: current_user.id, room_id: params['room'], login: true).empty?
      	return false
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists?
        return false
      end
      if Usermanager.where(ip_id: ip, room_id: params['room'], login: false).empty?
        return false
      end
    end
    unless current_user.present?
      if Usermanager.where(ip_id: ip, room_ban: false, room_id: params['room'].to_s, login: false, ng_word: true).exists?
        ng_word_params.each do |ng|
          if data['message'].include?(ng)
             return false
          end
        end
      end
    else
      if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s, login: true, ng_word: true).exists?
        ng_word_params.each do |ng|
          if data['message'].include?(ng)
            return false
          end
        end
      end
    end



    if data['message'].include?("https://www.youtube.com/watch?v=")
      urll = data['message'].gsub(/http.+v=/, "")
      url = urll.gsub(/&.+./, "")
    elsif data['message'].include?("https://youtu.be/")
      url = data['message'].gsub(/http.+be./, "")
    end
    messagesCount = Message.where(ip_id: ip).where('created_at > ?', secondsAgo).count
  	
    unless current_user.present?
      if messagesCount <= 5
        unless data['message'].nil?
          if Usermanager.where(ip_id: ip, room_ban: false, message_limit: false, room_id: params['room'].to_s, login: false).exists?
             if data['message'].length <= 1000
          		 @message = Message.create! content: data['message'], room_id: params['room'].to_s,username: "名無し",ip_id: ip, login: false, youtube_id: url, user_id: nil
        	   end
          end
         end
      end
    else

      if messagesCount <= 5
        unless data['message'].nil?
          if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s,  message_limit: false, login: true).exists?
            if data['message'].length <= 1000
    		       @message = Message.create! content: data['message'], user_id: current_user.id, room_id: params['room'].to_s,username: current_user.name, ip_id: ip, login: true, youtube_id: url
            end
          end
        end
      end
    end
  end
end
