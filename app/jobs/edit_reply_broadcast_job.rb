class EditReplyBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	ActionCable.server.broadcast "edit_channel_#{message.room_id}", render_message: render_message(message), render_nil_message: render_nil_message(message), reply_message_user_id: message.user_id, id: message.id, message_reply: true
  end

  def render_message(message)
  	ApplicationController.render_with_signed_in_user(message.user, partial: 'message_replies/message_reply', locals: { message_reply: message})
  end

  def render_nil_message(message)
  	ApplicationController.render_with_signed_in_user(nil, partial: "message_replies/message_reply", locals: {message_reply: message})
  end
end
