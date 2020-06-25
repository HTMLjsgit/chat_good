class Usermanager < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :room, optional: true
	has_many :messages, dependent: :destroy
end
