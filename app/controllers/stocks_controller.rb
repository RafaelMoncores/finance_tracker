class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock && @stock.valid?
        respond_to do |format|
          format.js { render partial: "users/result" }
        end
      else
        flash[:alert] = "Stock not found. Please check the symbol and try again."
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a symbol to search"
      redirect_to my_portfolio_path
    end
  end
end
