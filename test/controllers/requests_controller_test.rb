require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  
  setup do
    @requestOne = requests(:one)
    @requestTwo = requests(:two)
    @requestThree = requests(:three)

    @coordinates = {
      northEastLng: -73.73778836447514,
      southWestLng: -74.25963895041264,
      northEastLat: 41.051762575669265,
      southWestLat: 40.32283848308042
    }
    @requestCoordinates = { name: 'Queens, NY 11367', lat: 40.726864,  lng: -73.8189582 }
    post login_users_url, params: { user: { email: 'jack@gmail.com', password: 'password' } }, as: :json
    @logged_in_user = JSON.parse(response.body)
    #puts @response.body
  end


  test "should create request" do
    assert_difference('Request.count') do
      post requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: @requestOne.title, description: @requestOne.description, category: @requestOne.category, location: @requestCoordinates[:name], latitude: @requestCoordinates[:lat], longitude: @requestCoordinates[:lng] } }, as: :json
    end
    assert_response 201
  end

  test "should not create request without auth_token" do
    assert_no_difference('Request.count') do
      post requests_url, headers: { Authorization: '', ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: @requestOne.title, description: @requestOne.description, category: @requestOne.category, location: @requestCoordinates[:name], latitude: @requestCoordinates[:lat], longitude: @requestCoordinates[:lng] } }, as: :json
    end
    assert_response 401
  end

  test "should not create request without location" do
    assert_no_difference('Request.count') do
      post requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: @requestOne.title, description: @requestOne.description, category: @requestOne.category, location: '', latitude: '', longitude: '' } }, as: :json
    end
    assert_response 422
  end

  test "should not create request with description of more than 300 char" do
    assert_no_difference('Request.count') do
      post requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: @requestOne.title, 
        description: 'Rails makes it super easy to write your tests. It starts by producing skeleton test code while you are creating your models and controllers. By running your Rails tests you can ensure your code adheres to the desired functionality even after some major code refactoring. Rails tests can also simulate browser requests and thus you can test your application\'s response without having to test it through your browser.', 
        category: @requestOne.category, location: @requestCoordinates[:name], latitude: @requestCoordinates[:lat], longitude: @requestCoordinates[:lng] } }, as: :json
    end
    assert_response 422
  end

  test "should not create request without category" do
    assert_no_difference('Request.count') do
      post requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: @requestOne.title, description: @requestOne.description, category: '', location: @requestCoordinates[:name], latitude: @requestCoordinates[:lat], longitude: @requestCoordinates[:lng] } }, as: :json
    end
    assert_response 422
  end

  test "should not create request without title" do
    assert_no_difference('Request.count') do
      post requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { user_id: @logged_in_user["id"], title: '', description: @requestOne.description, category: @requestOne.category, location: @requestCoordinates[:name], latitude: @requestCoordinates[:lat], longitude: @requestCoordinates[:lng] } }, as: :json
    end
    assert_response 422
  end

  test "should get requests for the map" do
    post map_requests_requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { northEastLng: @coordinates[:northEastLng], southWestLng: @coordinates[:southWestLng], northEastLat: @coordinates[:northEastLat], southWestLat: @coordinates[:southWestLat] } }, as: :json
    assert_response 200
  end

  test "should  get users requests" do
    get user_requests_requests_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
    assert_response 200
  end

   test "should get total number of not fullfilled requests" do
    get count_requests_url, as: :json
    count = JSON.parse(response.body)
    assert_response 200
    assert_equal 3, count["total"] 
  end

  test "should delete request" do
    assert_difference('Request.count', -1) do
      delete request_url(@requestOne), headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
    end
    assert_response 204
  end

  test "should update request status" do
    patch request_url(@requestOne), headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { status: 'fullfilled' } }, as: :json
     request = JSON.parse(response.body)
    assert_response 200
    assert_equal request["status"], 'fullfilled'
  end

  test "should update request active" do
    patch request_url(@requestOne), headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { request: { active: 0 } }, as: :json
     request = JSON.parse(response.body)
    assert_response 200
    assert_equal request["active"], 0
  end

  test "should increase request start count by 1 when conversation created" do
    old_start_count = @requestTwo.start_count
    assert_difference('Conversation.count') do
      post conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { conversation: { request_id: @requestTwo.id, to_id: 1, subject: 'help out', body: 'ok great' } }, as: :json
    end 
    assert_response 201

    get request_url(@requestTwo), headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
     assert_response 200
     result = JSON.parse(@response.body)
     assert_equal old_start_count + 1, result["start_count"]
  end

  test "should make request inactive when conversation created and request start count equals 4" do
    old_start_count = @requestThree.start_count
    assert_difference('Conversation.count') do
      post conversations_url, headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, params: { conversation: { request_id: @requestThree.id, to_id: 1, subject: 'help out', body: 'ok great' } }, as: :json
    end 
    assert_response 201

    get request_url(@requestThree), headers: { Authorization: @logged_in_user["auth_token"], ACCEPT: 'application/json' }, as: :json
     assert_response 200
     result = JSON.parse(@response.body)
     assert_equal result["active"], 0
     assert_equal result["start_count"], 5
  end


end
