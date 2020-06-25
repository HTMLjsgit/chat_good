class UsermanagersController < ApplicationController
	before_action :room_find
	before_action :usermanager_find, only: [:update, :show]
	before_action :usermanager_room_ban
	def update
		@usermanager.update(update_params)
		redirect_back(fallback_location: rooms_path)
	end

  	def index
      @users = User.all
      @managers = Usermanager.all
	end

	def show
	    @user = @usermanager.user
	    @messages = @room.messages
	end

	def destroy
		@room = Room.find params[:room_id]
		usermanager_id = Usermanager.find params[:id]
		if user_signed_in?
			if @room.user_id == current_user.id
				redirect_back(fallback_location: root_path)
			end 
		end
		Usermanager.find_by(id: usermanager_id).destroy
		redirect_to rooms_path
	end

	private
		def is_mine
			if @room.user_id != current_user.id
				redirect_to rooms_path
			end
		end

		def usermanager_find
			@usermanager = Usermanager.find params[:id]
		end

		def room_find
			@room = Room.find params[:room_id]
		end

		def update_params
			params.require(:usermanager).permit(:room_ban, :message_limit, :url_limit, :ng_word)
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
