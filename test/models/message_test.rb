require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  test "is valid with required data" do
    convo = Message.new(conversation_id: 1, to_id: 1, from_id: 2, body: 'Hello world')
    assert convo.valid?
  end

  test "is invalid without message body" do
    message = Message.new(conversation_id: 1, to_id: 1, from_id: 2, body: '')
    assert_not_nil message.errors[:body]
  end

  test "is invalid if ids not integers" do
    message = Message.new(conversation_id: '1.3', to_id: '1.3', from_id: 'hsf', body: 'Hello')
    refute message.valid?
    assert_not_nil message.errors[:conversation_id]
    assert_not_nil message.errors[:to_id]
    assert_not_nil message.errors[:from_id]
  end

end
