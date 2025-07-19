# app/services/alpha_vantage_service.rb
require "httparty"

class AlphaVantageService
  include HTTParty
  base_uri "https://www.alphavantage.co"

  def initialize
    @api_key = Rails.application.credentials.alpha_vantage[:api_key]
    raise "Alpha Vantage API Key is not set in credentials!" unless @api_key
  end

  # Método para obter dados de séries temporais diárias (Daily Adjusted)
  # Mais detalhes: https://www.alphavantage.co/documentation/#dailyadj
  def get_daily_adjusted(symbol)
    options = {
      query: {
        function: "TIME_SERIES_DAILY_ADJUSTED",
        symbol: symbol,
        apikey: @api_key
      }
    }
    self.class.get("/query", options)
  end

  # Método para obter a cotação em tempo real (Quote)
  # Mais detalhes: https://www.alphavantage.co/documentation/#quote
  def get_quote(symbol)
    options = {
      query: {
        function: "GLOBAL_QUOTE",
        symbol: symbol,
        apikey: @api_key
      }
    }
    self.class.get("/query", options)
  end

  # Exemplo de como você poderia lidar com erros ou limites de taxa
  def handle_response(response)
    if response.success?
      # Alpha Vantage frequentemente retorna um objeto JSON mesmo em erros
      # que podem incluir uma chave "Error Message" ou "Note"
      if response.parsed_response["Error Message"]
        puts "Alpha Vantage API Error: #{response.parsed_response["Error Message"]}"
        nil
      elsif response.parsed_response["Note"] # Limite de requisições, por exemplo
        puts "Alpha Vantage API Note: #{response.parsed_response["Note"]}"
        nil
      else
        response.parsed_response
      end
    else
      puts "HTTP Error: #{response.code} - #{response.message}"
      nil
    end
  end
end
