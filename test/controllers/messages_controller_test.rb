require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:one)
    post login_users_url, params: { user: { email: 'jack@gmail.com', password: 'password' } }, as: :json
    @logged_in_user = JSON.parse(response.body)
    
  end


  test "should get index" do
    get messages_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
    assert_response :success
  end

  test "should create message" do
    assert_difference('Message.count') do
      post messages_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { message: { conversation_id: 1, from_id: 1, to_id: 2, body: "ok great its working" } }, as: :json
    end
    assert_response 201
  end

  test "should get conversation messages" do
    get '/conversation/1/messages', headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json

    assert_response 200
  end

end
