class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
 	  ActionCable.server.broadcast "room_channel_#{message.room_id}", message_nil: render_message(message),message_user_id_nil: message.user_id
    # ActionCable.server.broadcast "room_channel_#{message.room_id}_#{user.id}", message: render_message(message, user)
    # puts "=-------------------------"

  end
  private

  def render_message(message)
  	# ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
    ApplicationController.render_with_signed_in_user(nil,partial: 'messages/message', locals: { message: message})

  end
end
