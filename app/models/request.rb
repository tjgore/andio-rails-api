class Request < ApplicationRecord
	belongs_to :user, optional: true

	has_many :conversations_requests
  has_many :conversations, through: :conversations_requests

	validates :user_id, :title, :category, :status, :location, :latitude, :longitude, presence: true
  validates :latitude, :longitude, format: { with: /[0-9\-\+\.]/ }
	validates :user_id, numericality: { only_integer: true }
	validates :category, length: { maximum: 50 }
	validates :description, allow_blank: true, length: { maximum: 300 }

end
