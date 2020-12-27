class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :trackable
  has_many :messages, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :usermanagers, dependent: :destroy
  has_many :passwordmanagers, dependent: :destroy
  has_many :active_notifications, dependent: :destroy, class_name: "Notification", foreign_key: "visitor_id"
  has_many :passive_notifications, dependent: :destroy, class_name: "Notification", foreign_key: "visited_id"
  has_many :message_replies, dependent: :destroy
  protected
  	def self.find_for_google(auth)
  		user = User.where(uid: auth.uid, provider: auth.provider).first
  		unless user
  			user = User.create!(name: auth.info.name,
  								email: User.dummy_email(auth),
  								provider: auth.provider,
  								token: auth.credentials.token,
  								password: Devise.friendly_token[0, 20],
  								uid: auth.uid)
  		end
  		user
  	end
  	private

  	def self.dummy_email(auth)
  		"#{auth.uid}-#{auth.provider}@example.com"
  	end
end
