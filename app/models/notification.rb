class Notification < ApplicationRecord
  belongs_to :visitor, class_name: "User", optional: true
  belongs_to :visited, class_name: "User", optional: true
  belongs_to :message, optional: true
  belongs_to :message_reply, optional: true
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  ACTION_VALUES = ["message"]
  validates :action, presence: true, inclusion: {in: ACTION_VALUES}
  
  after_create_commit { MessageNotificationJob.perform_later self }
end
