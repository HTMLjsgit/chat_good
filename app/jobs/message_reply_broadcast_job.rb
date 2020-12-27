class MessageReplyBroadcastJob < ApplicationJob
  queue_as :default
  def perform(message)
 	  ActionCable.server.broadcast "room_channel_#{message.room_id}",render_message_admin: render_message_admin(message), message_reply_nil: render_message(message),message_user_reply_id: message.user_id, bot: message.bot, message_id: message.message_id, user_id: message.user_id

  end
  private

  def render_message(message)
      ApplicationController.render_with_signed_in_user(nil,partial: 'message_replies/message_reply', locals: { message_reply: message})
  end

  def render_message_admin(message)
  	ApplicationController.render_with_signed_in_user(message.user, partial: 'message_replies/message_reply', locals: {message_reply: message})
  end
end
