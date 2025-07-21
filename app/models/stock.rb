class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    client = AlphaVantageClient.new
    client.price(ticker_symbol)
  end
end
