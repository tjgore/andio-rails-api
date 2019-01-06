require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  
  test "is valid with required data" do
    request = Request.new(title: "Picking up groceries", user_id: 1, location: "Queens, NY 11367", latitude: 40.726864, longitude: -73.8189582,  description: "pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: 'service')
    assert request.valid?
  end

  test "is invalid with description over 300 characters" do
    request = Request.new(title: "Picking up groceries", user_id: 1, location: "Queens, NY 11367", latitude: 40.726864, longitude: -73.8189582,  description: "pick up apples, bread, 2 boxes of milk, eggs, chips, jam, salt, ham, cheese, gallon of water, flour, oranges, peanuts, popcorn, rice, five boxes of kraft mac and cheese, beef, cup of noodles, turkey, potatoes, tomatoes, ten onions, garlic, and chicken breast Thank you! Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries,", category: 'service')
    refute request.valid?
    assert_not_nil request.errors[:description]
  end

  test "is invalid without title" do
    request = Request.new(title: "", user_id: 1, location: "Queens, NY 11367", latitude: 40.726864, longitude: -73.8189582,  description: "pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: 'service')
    refute request.valid?
    assert_not_nil request.errors[:title]
  end

  test "is invalid without user_id" do
    request = Request.new(title: "Picking up groceries", user_id: '', location: "Queens, NY 11367", latitude: 40.726864, longitude: -73.8189582,  description: "pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: 'service')
    refute request.valid?
    assert_not_nil request.errors[:user_id]
  end

  test "is invalid without location coordinates" do
    request = Request.new(title: "Picking up groceries", user_id: '1', location: "", latitude: '', longitude: '',  description: "pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: 'service')
    refute request.valid?
    assert_not_nil request.errors[:location]
    assert_not_nil request.errors[:latitude]
    assert_not_nil request.errors[:longitude]
  end

  test "is invalid without category" do
    request = Request.new(title: "Picking up groceries", user_id: '1', location: "Queens, NY 11367", latitude: 40.726864, longitude: -73.8189582,  description: "pick up apples, bread, milk, eggs, chips, jam, salt, and chicken breast Thank you", category: '')
    refute request.valid?
    assert_not_nil request.errors[:location]
    assert_not_nil request.errors[:latitude]
    assert_not_nil request.errors[:longitude]
  end

end
