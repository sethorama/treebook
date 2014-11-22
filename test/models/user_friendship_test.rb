require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works" do 
  	assert_nothing_raised do
  		UserFriendship.create user: users(:seth), friend: users(:rocky)
  	end
  end

  test "that creating a friendship based on iser id and friend id works" do
    UserFriendship.create user_id: users(:seth).id, friend_id: users(:rocky).id
    assert users(:seth).friends.include?(users(:rocky))
  end

end
