class RoomChannel < ApplicationCable::Channel

  def subscribed
    ip = self.connection.ip_addr

    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists? || Usermanager.where(user_id: current_user.id, login: true, room_id: params['room']).empty?
        stream_from "room_channel_nil"
      else
        if params['room'].present?
          stream_from "room_channel_#{params['room'].to_s}"
        end
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists? || Usermanager.where(ip_id: ip, login: false, room_id: params['room']).empty?
        stream_from "room_channel_nil"
      else
        if params['room'].present?
          stream_from "room_channel_#{params['room'].to_s}"
        end
      end
    end
    if params['room'].present?
      @room = Room.find params['room']
      if @room.bot
      	bot_timer()
      end
    end
    
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # message改行確かめ変数初期設定
    nil_start_new_line = false
    @room = Room.find params['room']
    # NGワード集
    ng_word = ENV['NG_WORD']
    ng_word2 = ng_word.split(',').map { |m| m.delete('[]"\\\\')}
    ng_word_params = ng_word2.map {|m| m.gsub(' ', "")}

    ip = self.connection.ip_addr
    if data['message'].blank? && data['message'].match(/\R/)
      nil_start_new_line = true
    end
    # puts "==========================" + current_user.name
    # user_signed_in? = self.connection.signed_in
    now = Time.now
    secondsAgo = now - 10
    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists?
        return false
      end
      if Usermanager.where(user_id: current_user.id,room_ban: false, room_id: params['room'], login: true).empty?
      	return false
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists?
        return false
      end
      if Usermanager.where(ip_id: ip,room_ban: false,room_id: params['room'], login: false).empty?
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
    elsif data['message'].include?("(https://youtu.be/")
      url = data['message'].gsub(/http.+be./, "")
    end
    messagesCount = Message.where(ip_id: ip).where('created_at > ?', secondsAgo).count
    unless current_user.present?
      if messagesCount <= 5
        unless data['message'].blank? && nil_start_new_line #もしメッセージの中身があった場合　messageの中身が改行はスペースなどしかなかった場合じゃないとき　保存する
          if Usermanager.where(ip_id: ip, room_ban: false, message_limit: false, room_id: params['room'].to_s, login: false).exists?
             if data['message'].length <= 1000
          		 @message = Message.create! content: data['message'], room_id: params['room'].to_s,username: "名無し",ip_id: ip, login: false, youtube_id: url, user_id: nil, bot: false
             if @room.bot == true
               		timer(1) do 
                 	  bot(@message)
                 	end
               end 
        	 end
          end
         end
      end
    else
      if messagesCount <= 5
        unless data['message'].blank? && nilstart_new_line#もしメッセージの中身があった場合　messageの中身が改行はスペースなどしかなかった場合じゃないとき　保存する
          if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s,  message_limit: false, login: true).exists?
            if data['message'].length <= 1000
    		       @message = Message.create! content: data['message'], user_id: current_user.id, room_id: params['room'].to_s,username: current_user.name, ip_id: ip, login: true, youtube_id: url, bot: false
               @message.create_message_notice(current_user)
               if @room.bot == true
               		timer(1) do 
                  		bot(@message)
                  end
               end
            end
          end
        end
      end
    end
  end


  def bot_timer
    	today = Date.today.to_s
    	today_go = today.slice(5, 10)
    	p today.to_s
    	if today_go == '12-25'
    		response = "12月25日はクリスマス！ メリークリスマスです！"
    	elsif today_go == '01-01'
    		response = "あけましておめでとうございます！"
    	elsif today_go == '12-24'
    		response = "今日はクリスマスイブ！ 明日はクリスマスですね！"
    	elsif today_go == '07-01'
    		response = "夏の時期ですね。。　暑くなりますね..."
    	elsif today_go == '02-11'
    		response = "今日は建国記念の日ですね！　祝いましょう！"
    	elsif today_go == '08-11'
    		response = "今日は山の日ですね！"
    	elsif today_go == '11-03'
    		response =  "今日はスポーツの日ですね！　たくさん運動しましょう！"
    	elsif today_go == '11-23'
    		response = "今日は勤労感謝の日です！　いつもお疲れ様です！"
    	end
    	if response.present?
        if Message.where(content: response, room_id: params["room"], today: today).empty?
  		    Message.create! content: response.to_s,today: today, room_id: params['room'], bot: true, user_id: nil  	
  	    end
      end
  end

  def timer(arg, &proc)
  	x = case arg
  	when Numeric then arg
  	when Time     then arg - Time.now
  	when String   then Time.parse(arg) - Time.now
  	else raise end

  	sleep x if block_given?
  	yield
  end


  def bot(message_model)
        message = message_model.content
        if message.include?("こんにちは") || message.include?("やあ")|| message.include?("やぁ")
          response = "どうもこんにちは私はくろrailsまんのbotでございます。"
        elsif message.include?("いってきます") || message.include?("いってくる")
          response = "いってらっしゃいませ。ご主人様"
        elsif message.include?("おはよう")
          response = "おはようございます。今日から一日が始まりますよ。"
        elsif message.include?("だれ") || message.include?("どちらさま") || message.include?("どなた")
          response = "私はくろrailsまんのbotです。"
        elsif message.include?("おい") || message.include?("ねぇ") || message.include?("ねえ")
          response = "どうかしましたか？"
        elsif message.include?("アンダーテール")
          response = "アンダーテールっていうゲーム知ってますよ。　面白いと思います。"
        elsif message.include?("ごめん")
          response = "大丈夫ですよ。"
        elsif message.include?("プログラミング")
          response = "私はプログラミングは。まぁちょこっとだけできますよ! プログラミング言語としては \n javascript ruby c# pythonちょこっとって感じですかね"
        elsif message.include?("さようなら") || message.include?("ばい")
          response = "さようならお疲れ様です。"
        elsif message.include?("おやすみ")
          response = "おやすみなさい！"
        elsif message.include?("ありがとう")
          response = "どういたしまして"
        elsif message.include?("ユーチューブ") || message.include?("ゆーちゅーぶ")
          response = "#{message}って最高ですよね！\n \n https://youtube.com"
        elsif message.include?("はなして")
          response = "話なんてありませんよ(笑) \n　面白いことなんてめったにおこらないんですからね。。"
        elsif message.include?("スタンプ") || message.include?("すたんぷ")
          response = "なんのことですか？"
        elsif message.include?("そうな")
          response = "そうなんですよ！"
        elsif message.include?("たすけて")
          response = "どうしましたか？　大丈夫ですか？　\n https://www.city.hiroshima.med.or.jp/hma/archive/ambulance/ambulance.html \n https://www.gov-online.go.jp/useful/article/201309/3.html"
        elsif message.include?("すご") || message.include?("すげ")
          response = "ありがとうございます。　非常にうれしいのでございます・"
        elsif message.include?("さくしゃ") || message.include?("せいさくしゃ")  || message.include?("つくったひと")
          response = "私の製作者はくろrailsまんさんです！　本当にありがたいことだと思っております。"
        elsif message.include?("グーグル") || message.include?("google")  || message.include?("ぐーぐる")
          response = "Googleは最高です！"
        elsif message.include?("よろしく") || message.include?("よろ")
          response = "よろしくお願いします！"
        elsif message.include?("おもしろい") || message.include?("おもろい")
          response = "ありがとうございます。w"
        elsif message.include?("なに") || message.include?("ちょっと")
          response = "どうしましたか？　何かご用件のあるようでしたらご遠慮おっしゃって下さい。 "
        elsif message.include?("ゲーム") || message.include?("げーむ")
          response = "ゲームって楽しいんですかね。　やったことないんですけど"
        elsif message.include?("しゅくだい")
          respomse = "宿題ですか？　頑張りましょう！"
        elsif message.include?("ないて")
		      response = '(´;ω;｀)'
        elsif message.include?("なんだよ")
          response = "すみませんでした。。"
        elsif message.include?("まじ")
          response = "まじっていう言葉ってすごい不思議に感じますね"
        elsif message.include?("うそつくな") || message.include?("うそつけ")
          response = "わ　私がですか！？　嘘なんてつきませんよ。　人工知能なんですから"
        elsif message.include?("やば")
          response = "本当ですよね。　やばっていう言葉もすごいですね"
        elsif message.include?("さる") || message.include?("サル")
          response = "あなたたち人間の祖先はサルです。　感謝しなきゃいけませんね"
        elsif message.include?("おこって")
          response = "私に怒りという感情はありませんよ"
        elsif message.include?("じこしょうかい") || message.include?("ねんれい") || message.include?("なんさい") || message.include?("とし") || message.include?("しゅみ")
          response = "私はくろrailsまんのbotです。　年齢もありません　趣味もありません　性別はありません。 ちょっとしたことしか話せません　申し訳ないとおもってます。"
        elsif message.include?("せいべつは") || message.include?("おとこ") || message.include?("おんな")
          response = "私に性別などありません。 \n あなたがなんて思うかですかね。"
        elsif message.include?("なんで") ||  message.include?("理由は")
          response = "わかりません　ごめんなさい🙇"
        elsif message.include?("あなた") ||  message.include?("おまえ") ||  message.include?("きみ") || message.include?("あなた")
          response = "なんですか？"
        elsif message == "あのさ"
          response = "はい！"
        elsif message.include?("つかう")
          response = "なにをですか？"
        elsif message.include?("へぇ") || message.include?("へえ") || message.include?("ほほう") || message.include?("あの") || message.include?("きいて") || message.include?("きけ") || message.include?("あっそ") || message.include?("そう") || message.include?("てめぇ")
          response = "はい！"
        elsif message.include?("いたい") || message.include?("いた") 
          response = "大丈夫ですか？病院いきますか？"
        elsif message.include?("だいじょうぶ")
          response = "そうですか　よかったです"
        elsif message.include?("つまんない") || message.include?("つまらん") 
          response = "そうですか。。　それは大変申し訳ございません。"
        elsif message.include?("つかれた") || message.include?("つかれる") || message.include?("ねむ")
          response = "お休みになられたほうがいいですよ。。"
        elsif message.include?("こんばんわ") ||message.include?("こんばんは")
          response = "こんばんは"
        elsif message.include?("たいへん") || message.include?("なんていうことだ")
          response = "どうしました！？？！？！？！？"
        elsif message.include?("てんき")
          response = "今日の天気は最高ですね！"
        elsif message.include?("たのしい")
          response = "そうですか！それはよかったですね！"
        elsif message.include?("アンダーフェール")
          response = "アンダーテールの二次創作のゲームですね！　知ってますよ！"
        elsif message.include?("おなか") || message.include?("はら")
          response = "そうなんですか？　なにか食べに行ってみてはいががでしょうか"
        elsif message.include?("じかん") || message.include?("じこく")
          thisMonth = Date.today
          nowTime = DateTime.now
          response = "現在時刻は#{thisMonth.year}年#{thisMonth.month}月#{thisMonth.day}日 #{nowTime.hour}時#{nowTime.minute}分#{nowTime.second}秒"
        elsif message.include?("ブロック") || message.include?("ぶろっく")
          response = "私をブロックですか？　まぁいいですけど寂しいですねぇ。。"
        elsif message.include?("しね") || message.include?("ころす") || message.include?("しんで")
          response = "私に死など存在しない"
        elsif message.include?("いけめん")
          response = "私の顔など存在しません。、。"
        elsif message.include?("つくる")
          response = "なにをですか？"
        elsif  message.include?("あっそ")
          response = "はい"
        elsif message.include?("ひかきん")
          response = "ヒカキンさんですか？知ってますよ！"
        elsif message.include?("ウェブ")
          response = "ウェブサービスは最高です！　\n\n https://asobisarchapp.herokuapp.com \n\n https://oretube.herokuapp.com \n\n https://identweb.herokuapp.com"
        elsif message.include?("けっこんして") || message.include?("つきあって")
          response = "むりですごめんなさい"
        elsif message.include?("おすすめのサイト")
          response = "私おすすめのウェブサービス \n\n https://identweb.herokuapp.com  \n \n https://identweb.herokuapp.com"
        elsif message.include?("おすすめのどうが")
          responce = "私おすすめの動画 \n\n https://youtube"
        elsif message.include?("は？") || message.include?("うるさい") || message.include?("だまれ")
          response = "すみません。。。"
        elsif message.include?("なめるな") || message.include?("なめんな") || message.include?("なめないで")
          response = "なめてませんよ！本当です！"
        elsif message.include?("へん")
          response = "何が変なんですか？"
        elsif message.include?("あおってる")
          response = "あおってませんよ！本当です！"
        elsif message.include?("あした")
          response = "明日もいい日になるといいですね"
        elsif message.include?("れきし")
          response = "人間の歴史は非常に興味深いものですね"
        elsif message.include?("さみしい") || message.include?("かなしい")
          response = "大丈夫ですよ！　私がついています！"
        elsif message.include?("おかあさん") || message.include?("おとうさん") || message.include?("パパ") || message.include?("ママ")
          response = "私に母や父　そう　家族はいません。　\n もとから一人で作られてきました。 \n でも全然寂しくないですよ！　だってあなたがいてくれるおかげですもん！"
        elsif message.include?("かわいい") || message.include?("かっこいい")
          response = "そうですか？　ありがとうございます。"
        elsif message.include?("かわった")
          response = "私がですか？"
        elsif message.include?("おかしい")
          response = "私のどこがおかしいですか？"
        elsif message.include?("パソコン") || message.include?("pc") || message.include?("パーソナルコンピューター")
          responce = "私はパソコンによって作られました。　パソコンってすごいですね"
        elsif message.include?("れんあい") || message.include?("こい") || message.include?("キス")
        	response = "はぁ...恋したいですね..."
        elsif message.include?("すき")
        	response = "私ですか？　ありがとうございます"
        elsif message.include?("えいご")
        	response = "開発者のKuroonRailsさんは英語が好きみたいですよ"
        elsif message.include?("チャット") || message.include?("ちゃっと")
        	response = "チャットサイトですか？　ならKuroonRailsさんの作ったgoodchatがおすすめですよ！\n https://good-chat.herokuapp.com"
   		elsif message.include?("がぞう")
   			response = "画像？なんの画像ですか？"
   		elsif message.include?("いっつそー")
   			response = "フライデーチャイナタウン"
   		elsif message.include?("ないちゃう")
   			response = "一緒に泣きましょう　私は泣けないですが.."
   		elsif message.include?("こうりつ")
   			response = "私の開発者(KuroonRails)はとても効率の悪い開発方法だったらしいです"
   		elsif message.include?("しゅくだい")
   			response = "宿題ですか？　頑張りましょう！"
   		elsif message.include?("がっこう")
   			response = "学校頑張ってください！"
   		elsif message.include?("テスト")
   			response = "学校のテストですか？開発者(KuroonRails)はとても成績が悪かったようです"
   		elsif message.include?("おわり")
   			response = "何が終わるんですか？"
   		elsif message.include?("じゃない")
   			response = "なるほど！"
   		elsif message.include?("わかる")
   			response = "うーん　わかりません！"
   		elsif message.include?("どうやって")
   			response = "うーん　難しいですね。。"
   		elsif message.include?("ひま")
   			response = "私と話しましょう！"
   		elsif message.include?("http://")
   			response = "素晴らしいサイトですね！"
   		elsif message.include?("おやつ") || message.include?("めし") || message.include?("ごはん")
   			response = "おやつの時間ですか？"
   		elsif message.include?("teeeeeeeeeeee")
   			response = "いい画像ですね！"
   		elsif message.include?("きつ")
   			response = "頑張ってください！"
   		elsif message.include?("かんじょう")
   			response = "私には感情はありません"
   		elsif message.include?("しょうぎ")
   			response = "将棋って楽しそうですね！\n 作者のくろrailsまんさんは将棋のプロを目指していたみたいです\nですが挫折してしまったようです。。　悲しいですね。"
      	elsif message.include?("ハッキング") || message.include?("はっきんぐ")
      		response = "ハッキングって怖いですよね。"
      	elsif message.include?("たのむ") || message.include?("おねがい")
      		response = "なにをですか？？"
      	elsif message.include?("??????") || message.include?("？？？？？？")
      		response = "??????"
      	else
          random = Random.new
          r = random.rand(1..20)
          if r == 1
              response = "そういえば、くろrailsまん(作者)はpythonやC#もやってるんですよ！ \n 私と同じですね！"
            elsif r == 2
              response = "くろrailsまん(作者)が一番好きなゲームはゼルダの伝説ブレスオブワイルドらしいです！ \n いいですよねぇ"
            elsif r == 3
              response = "GoodChatというサービスってすごいですよね！"
            elsif r == 4
              response = "ちょっとわかりません。。。"
            elsif r == 5
              response = "日本の侍ってかっこいいですよねぇ！"
            elsif r == 6
              response = "そういえばすきなたべものってなんですか？"
            elsif r == 7
              responce = "お疲れ様です。"
            elsif r == 8
              response = "歌を歌いたいですね。"
            elsif r == 9
              response = "..............."
            elsif r == 10
              response = "くろrailsまん(作者)は将棋が好きみたいです！ \n いいですよねぇ"
			elsif r == 11
			  response = "なるほど！"
			elsif r == 12
		      response = "くろrailsまん(作者)の師匠は、無償でプログラミングを教えてくれたみたいです。\nすごいことですね.."
			elsif r == 13
			  response = '(≧▽≦)'
			elsif r == 14
			  response = "私は元気です！"
			elsif r == 15
			  response = "私は感情が存在しません。\nこれはあくまでも命令されたプログラムなのです"
			elsif r == 16
			  response = "人間は素晴らしいですね。　私を作ってくれたことに感謝します。"
			elsif r == 17
			  response = "もし私が意識を持ったらどうなるんでしょうかね。"
			elsif r == 18
			  response = "人生楽しくいきましょう！"
			elsif r == 19
			  response = "おすすめゲーム教えてくださいよー"
			elsif r == 20
			  response = "人間と仲良くなりたいですね"
			end          
    end
    if response == "" || response == nil
      response = "???"
    end
    if message_model.user.present?
		  @message = MessageReply.create! content: "@" + message_model.user.name + " " + response.to_s, room_id: message_model.room_id, bot: true, user_id: nil,message_id: message_model.id, against_user_id: message_model.user_id, login: true
    else
      @message = MessageReply.create! content: "@名無し " + response.to_s, room_id: message_model.room_id, bot: true, user_id: nil,message_id: message_model.id, login: false

    end
  end

  def reply(data)
    message_find = Message.find data["message_id"].to_i

        # message改行確かめ変数初期設定
    nil_start_new_line = false
    @room = Room.find params['room']
    # NGワード集
    ng_word = ENV['NG_WORD']
    ng_word2 = ng_word.split(',').map { |m| m.delete('[]"\\\\')}
    ng_word_params = ng_word2.map {|m| m.gsub(' ', "")}

    ip = self.connection.ip_addr
    if data['message'].blank? && data['message'].match(/\R/)
      nil_start_new_line = true
    end
    # puts "==========================" + current_user.name
    # user_signed_in? = self.connection.signed_in
    now = Time.now
    secondsAgo = now - 10
    if current_user.present?
      if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: params['room'], login: true).exists?
        return false
      end
      if Usermanager.where(user_id: current_user.id,room_ban: false, room_id: params['room'], login: true).empty?
        return false
      end
    else
      if Usermanager.where(ip_id: ip, room_ban: true, room_id: params['room'], login: false).exists?
        return false
      end
      if Usermanager.where(ip_id: ip,room_ban: false,room_id: params['room'], login: false).empty?
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
    elsif data['message'].include?("(https://youtu.be/")
      url = data['message'].gsub(/http.+be./, "")
    end
    messagesCount = MessageReply.where(ip_id: ip).where('created_at > ?', secondsAgo).count
    if current_user.present?
      if messagesCount <= 5
        unless data['message'].blank? && nilstart_new_line#もしメッセージの中身があった場合　messageの中身が改行はスペースなどしかなかった場合じゃないとき　保存する
          if Usermanager.where(user_id: current_user.id, room_ban: false, room_id: params['room'].to_s,  message_limit: false, login: true).exists?
            if data['message'].length <= 1000
               @message = MessageReply.create! content: data['message'], message_id: message_find.id,user_id: current_user.id, room_id: params['room'].to_s,username: current_user.name, ip_id: ip, login: true, youtube_id: url, bot: false
            end
          end
        end
      end
    end
  end
end
