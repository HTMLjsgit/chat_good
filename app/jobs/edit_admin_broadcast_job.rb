class EditAdminBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	ActionCable.server.broadcast "edit_channel_#{message.room_id}", message: render_message(message), id: message.id,message_user_id: message.user_id
  end
  private

  def render_message(message)
  	# ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
     ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/message', locals: { message: message})
    
  end
end
