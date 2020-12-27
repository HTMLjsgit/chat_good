class MessageAdminBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	# p "=----------MESSAGEMESSAGEBROADCAST----------"
    # ActionCable.server.broadcast "room_channel_#{message.room_id}", message: render_message(message, user)
    # if user.present?
      ActionCable.server.broadcast "room_channel_#{message.room_id}", message: render_message(message), message_user_id: message.user_id
  	# end
  end
  private

  def render_message(message)
  	# ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
    ApplicationController.render_with_signed_in_user(message.user,partial: 'messages/message', locals: { message: message})
  end

  def reply_create_render(message)
    ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/message', locals: {mesage: message})
  end

end
