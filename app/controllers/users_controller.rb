class UsersController < ApplicationController
  def my_portfolio
    @user_stocks = current_user.user_stocks
  end
end
