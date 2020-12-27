class MessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
  	user = User.find notification.visited_id
  	count = user.passive_notifications.where(checked: false).count
  	ActionCable.server.broadcast "notice_channel_#{notification.visited_id}", notification: render_notice(notification), count: count
  end

  private

  def render_notice(notification)
  	ApplicationController.renderer.render partial: 'notifications/notification', locals: {notification: notification}
  end
end
