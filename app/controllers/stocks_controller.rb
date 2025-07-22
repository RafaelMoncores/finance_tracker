class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])

      if @stock && @stock.valid?
        flash.now[:notice] = "Stock '#{@stock.ticker}' found successfully!"
        render "users/my_portfolio"
      else
        flash[:alert] = "Could not get data for '#{params[:stock]}'. Please check the symbol and try again (API limit might be reached)."
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a symbol to search."
      redirect_to my_portfolio_path
    end
  end
end
