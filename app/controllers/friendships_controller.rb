class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend_id])
    current_user.friendships.create(friend: friend)
    redirect_to my_friends_path, notice: "Friend added!"
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to my_friends_path, notice: "Friend removed."
  end
end
