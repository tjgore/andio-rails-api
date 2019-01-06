class Conversation < ApplicationRecord 
  #belongs_to :user, optional: true
  validates :subject, presence: true
  
  has_many :messages
  has_many :conversations_requests
  has_many :request, through: :conversations_requests

end
