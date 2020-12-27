class NotificationsController < ApplicationController
	before_action :authenticate_user!
	def check_save
		@notifications = current_user.passive_notifications.where(checked: false)
		@notifications.update(checked: true)
		@count = current_user.passive_notifications.where(checked: false).count.to_s
		render 'create.js.erb'
	end
end
