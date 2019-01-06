class Message < ApplicationRecord
  belongs_to :conversation, optional: true
  #belongs_to :user, optional: true

  validates :conversation_id, :to_id, :from_id, :body, :read, presence: true
  validates :conversation_id, :to_id, :from_id, :read, numericality: { only_integer: true }
  validates :body, length: { maximum: 300 }
end
