require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
 
  test "is valid with required data" do
    convo = Conversation.new(subject: "Picking up groceries")
    assert convo.valid?
  end

end
