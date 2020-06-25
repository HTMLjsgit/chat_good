class UsersController < ApplicationController
	before_action :user_find
	before_action :is_mine, only: [:edit, :update]
	def show
		@rooms = @user.rooms
		@rooms_public = @user.rooms.where(public: true)
		@room_private = @user.rooms.where(public: false)
	end
	def edit
	end
	def update
		@user.update(create_params)
		redirect_to user_path(@user)
	end

	private
	def create_params
		params.require(:user).permit(:name, :profile)
	end
	def user_find
		@user = User.find params[:id]
	end

	def is_mine
		if @user.id != current_user.id
			redirect_to rooms_path
		end
	end
end
