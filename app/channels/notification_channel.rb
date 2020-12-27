class NotificationChannel < ApplicationCable::Channel
  def subscribed
  	if current_user.present?
    	stream_from "notice_channel_#{current_user.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def notice
  end
end
