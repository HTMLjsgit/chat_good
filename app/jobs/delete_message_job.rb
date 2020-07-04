class DeleteMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
  	ActionCable.server.broadcast "delete_channel", user_id: message.user_id
  end
end
