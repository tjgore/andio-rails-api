require 'test_helper'

class ConversationsRequestTest < ActiveSupport::TestCase
 
 test "is valid with required data" do
    convo = ConversationsRequest.new(conversation_id: 1, request_id: 1)
    assert convo.valid?
  end

  test "is invalid if data is not integer" do
    convo = ConversationsRequest.new(conversation_id: '1.4', request_id: '1.5')
    refute convo.valid?
    assert_not_nil convo.errors[:conversation_id]
    assert_not_nil convo.errors[:request_id]
  end

end
