class Passwordmanager < ApplicationRecord
	belongs_to :user, optional: true
	belongs_to :room
end
