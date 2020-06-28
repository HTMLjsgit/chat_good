class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :update, :edit,:create]
  before_action :room_find, only: [:edit, :update, :destory, :show, :password, :password_edit, :password_update, :room_certification_create, :room_certification]
  before_action :usermanager_room_ban, only: [:show, :room_certification_create, :room_certification]
  before_action :is_mine, only: [:edit, :update, :destroy, :password_edit,:password_upate]
  def index
  	# @rooms = Room.where(public: true).order(created_at: :desc)
    now = Time.now

  end

  def new
  	@room = Room.new
  end

  def create
  	@room = Room.new(create_params)
    @room.user_id = current_user.id
  	if @room.save!
  	  redirect_to rooms_path
    else
      render 'new'
    end
  end

  def edit
  end
  def show
    @messages = @room.messages
    # ここは公開ルームだった場合
    if user_signed_in?
      @current = current_user
    end



    if @room.public
      if user_signed_in?
      	# もしUsermanagerの中にルームIDとcurrent_user.idがなかった場合は保存する。
        if Usermanager.where(room_id: @room.id, user_id: current_user.id, login: true).empty?
          Usermanager.create(room_id: @room.id, user_id: current_user.id,ip_id: request.ip, login: true)
        end
      else
      	# もしUsermanagerの中にルームIDとrequst.ipがなかった場合は保存する。
       if Usermanager.where(room_id: @room.id, ip_id: request.ip, login: false).empty?
          Usermanager.create(room_id: @room.id,ip_id: request.ip, login: false)
        end
      end
    else
      # ここは非公開ルームだった場合　

      # 非公開ルームでかつ、パスワード設定が設定されてないのであれば、ルーム管理者以外の人はホームに強制移動。
      # 非公開ルームでかつ、パスワード設定が設定されてないのであれば、ルーム管理者以外の人はホームに強制移動。
      if @room.password.blank?
  	    if user_signed_in?
  		    if @room.user_id == current_user.id
  			   	redirect_to room_password_path
          end
  			else
  			 	redirect_to rooms_path
  			end
  		end
    # パスワードが設定されてたら？
      unless @room.password.blank?
        # もしルーム管理者じゃなかったらパスワード認証させる
        if user_signed_in?
        # ルーム管理者じゃなかったら？
          if @room.user_id != current_user.id
          # ルーム管理者ではない and Password認証ができてない場合はパスワード認証させておく。
            if Passwordmanager.where(room_id: @room.id, user_id: current_user.id, password: @room.password).empty?
              redirect_to room_certification_path
            end
          end
        else
        # ルーム管理者ではない and　ログインしてない and Password認証ができてない場合はパスワード認証させておく。
          if Passwordmanager.where(room_id: @room.id, ip_id: request.ip, password: @room.password).empty?
            redirect_to room_certification_path
          end
        end
      end

      # 条件に当てはまるUsermanagerがなかった場合は保存!
      if user_signed_in?
        if Usermanager.where(room_id: @room.id, user_id: current_user.id).empty?
           Usermanager.create(room_id: @room.id, user_id: current_user.id,login: true)
        end
      else
        if Usermanager.where(room_id: @room.id, ip_id: request.ip).empty?
            Usermanager.create(room_id: @room.id,ip_id: request.ip,login: false)
        end
      end
      @message = Message.new
    end
  end

  def password_edit
    # もし公開ルームだったらトップに飛ばす
    if @room.public
      redirect_back(fallback_location: rooms_path)
    end
  end

  def room_certification
    if @room.public
      redirect_back(fallback_location: rooms_path)
    end 
  end

  def room_certification_create # Password認証するところ。　Passwordmanagerを作成する
    if @room.public
      redirect_back(fallback_location: rooms_path)
    end
    password = params[:password]
    # パスワードがあてはまったら
    unless Room.find_by(id: @room.id,password: password).nil?
       if user_signed_in?
	       if Passwordmanager.where(user_id: current_user.id, room_id: @room.id, password: password).exists?
	       	  Passwordmanager.update(user_id: current_user.id, room_id: @room.id, password: password, ip_id: request.ip)
	       else
	      	  passwordmanager = Passwordmanager.new(user_id: current_user.id, room_id: @room.id,password: password, ip_id: request.ip)
	       end
	     else
  	      if Passwordmanager.where(ip_id: request.ip, room_id: @room.id, password: password).exists?
  	       	  Passwordmanager.update!(room_id: @room.id, password: password, ip_id: request.ip)
  	      else
  	       	passwordmanager = Passwordmanager.new(room_id: @room.id, password: password, ip_id: request.ip)
  	      end
       end
       passwordmanager.save!
       redirect_to room_path(@room)
    else
      render 'room_certification'
    end
  end

  def password_update # passwordを {{ 設定する }} ところ　!

  	# もし非公開ルームであった場合のみpasswordを設定できる。
    if @room.public == false
      password = params[:room][:password]
      @room.password = password
      # もし@room.passwordの中身があるならsaveして チャットルームにれダイレクト
      # もし@room.passwordの中身がないならsaveせずにrenderする。
      if @room.password.present?
        @room.save!
        redirect_to room_path(@room)
      else
        render 'password_edit'
      end
    else
  	# もし公開ルームだった場合はトップに強制れダイレクト
      redirect_back(fallback_location: rooms_path)
    end
  end

  def update
  	@room.update(create_params)
  	redirect_to room_path(@room)
  end

  def destroy
  	@room.destroy
  	redirect_to room_path(@room)
  end

  def usermessages
    @user = User.find params[:id]
    @messages = @user.messages
  end

  private
  def room_find
  	@room = Room.find params[:id]
  end
  def create_params
  	params.require(:room).permit(:title, :public, :password, :reading)
  end

  def is_mine
    if @room.user_id != current_user.id
      redirect_to rooms_path
    end
  end

  def usermanager_room_ban
    if user_signed_in?
        if Usermanager.where(user_id: current_user.id, room_ban: true, room_id: @room.id, login: true).exists?
            redirect_to rooms_path
        end
    else
      if Usermanager.where(ip_id: request.ip, room_ban: true, room_id: @room.id, login: false).exists?
        redirect_to rooms_path
      end
    end
  end
end
