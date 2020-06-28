class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(notification)

    html = ApplicationController.render partial: "notifications/message", locals: {notification: notification}, formats: [:html]
    ActionCable.server.broadcast "notifications:#{notification.recipient_id}", html: html
    # Do something later
  end
end
