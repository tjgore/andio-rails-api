require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conversation = conversations(:one)

    @requestOne = requests(:one)
    @requestTwo = requests(:two) 

    post login_users_url, params: { user: { email: 'jack@gmail.com', password: 'password' } }, as: :json
    @logged_in_user = JSON.parse(response.body)
    #puts @response.body
  end

  test "should get user conversations" do
    get conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
    assert_response :success
  end

  test "should not get conversations without user auth_token" do
    get conversations_url, headers: { Authorization:'', ACCEPT: 'application/json' }, as: :json
    assert_response 401
  end

  # if conversation with same users and requests is already in progress do not create a new 1
  test "should start new conversation when no conversation with request and users are the same" do
    assert_difference('Conversation.count') do
      post conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { conversation: { request_id: @requestTwo.id, to_id: 1, subject: 'help out', body: 'ok great' } }, as: :json
    end 
    result = JSON.parse(@response.body)
    assert_response 201
    assert result["conversation"]
    assert result["message"]
  end

  test "should create conversation and not add message without body" do
    assert_difference('Conversation.count') do
      assert_no_difference('Message.count') do
        post conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { conversation: { request_id: @requestTwo.id, to_id: 1, subject: 'help out', body: '' } }, as: :json
      end 
    end
    assert_response 422
  end

  test "should add message if conversation exists" do
    assert_no_difference('Conversation.count') do
      post conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { conversation: { request_id: @requestOne.id, to_id: 1, subject: 'help out', body: 'ok great' } }, as: :json
    end 
    result = JSON.parse(@response.body)
    assert_response 201
    assert_nil result["conversation"]
    assert result["message"]
  end

end
