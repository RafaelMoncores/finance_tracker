class UserStocksController < ApplicationController
  def create
    stock = Stock.check_db(params[:ticker])
    if stock.nil?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.new(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio." if @user_stock.save
    redirect_to my_portfolio_path
  end

  def destroy
    user_stock = current_user.user_stocks.find(params[:id])
    user_stock.destroy
    flash[:notice] = "#{user_stock.stock.ticker} was successfully removed from your portfolio."
    redirect_to my_portfolio_path
  end
end
