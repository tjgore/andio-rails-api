class ConversationsRequest < ApplicationRecord
  belongs_to :conversation, optional: true
  belongs_to :request, optional: true

  validates :conversation_id, :request_id, presence: true, numericality: { only_integer: true }
end
