class UsersController < ApplicationController
  def my_portfolio
    @user_stocks = current_user.user_stocks
  end

  def my_friends
    @friendships = current_user.friendships
  end

  def search_friend
    if params[:friend].present?
      @friends = User.where("email LIKE ? OR first_name LIKE ? OR last_name LIKE ?",
                            "%#{params[:friend]}%", "%#{params[:friend]}%", "%#{params[:friend]}%")
                     .where.not(id: current_user.id)
      flash.now[:notice] = "Friend(s) found!" if @friends.any?
      flash.now[:alert] = "No friends found with '#{params[:friend]}'" if @friends.empty?
    else
      @friends = []
      flash.now[:alert] = "Please enter a name or email to search."
    end
    @friendships = current_user.friendships
    render :my_friends
  end
end
