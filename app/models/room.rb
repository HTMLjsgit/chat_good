class Room < ApplicationRecord
	has_many :messages, dependent: :destroy
	has_many :usermanagers, dependent: :destroy
	has_many :passwordmanagers, dependent: :destroy
	belongs_to :user
	validates :title, presence: true, length: {maximum: 100}
	validates :body, presence: true, length: {maximum: 300}
	before_create :set_id
	has_many :message_replies, dependent: :destroy
	private
	def set_id
      # id未設定、または、すでに同じidのレコードが存在する場合はループに入る
      while self.id.blank? || Room.find_by(id: self.id).present? do
        # ランダムな20文字をidに設定し、whileの条件検証に戻る
        self.id = SecureRandom.alphanumeric(30)
      end
    end
end
