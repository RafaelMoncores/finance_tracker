require "httparty"

class AlphaVantageClient
  include HTTParty
  base_uri "https://www.alphavantage.co" # Endpoint padrão

  def initialize(api_key: nil, endpoint: nil)
    # Se uma API Key for passada, usa ela. Senão, tenta carregar das credenciais.
    @api_key = api_key || Rails.application.credentials.alpha_vantage[:api_key]
    raise "Alpha Vantage API Key is not set!" unless @api_key

    # Se um endpoint for passado, sobrescreve o base_uri.
    # Isso é útil para testes ou ambientes diferentes, mas raramente necessário para Alpha Vantage.
    self.class.base_uri(endpoint) if endpoint.present?
  end

  # --- Métodos para interagir com a API ---

  # Obter dados de séries temporais diárias (Daily Adjusted)
  # Documentação: https://www.alphavantage.co/documentation/#dailyadj
  def get_daily_adjusted(symbol)
    options = {
      query: {
        function: "TIME_SERIES_DAILY_ADJUSTED",
        symbol: symbol,
        apikey: @api_key
      }
    }
    handle_response(self.class.get("/query", options))
  end

  # Obter a cotação em tempo real (Global Quote)
  # Documentação: https://www.alphavantage.co/documentation/#quote
  def get_quote(symbol)
    options = {
      query: {
        function: "GLOBAL_QUOTE",
        symbol: symbol,
        apikey: @api_key
      }
    }
    handle_response(self.class.get("/query", options))
  end

  # Novo método: Obter o Overview da empresa (inclui nome da empresa, descrição, etc.)
  # Documentação: https://www.alphavantage.co/documentation/#company-overview
  def get_company_overview(symbol)
    options = {
      query: {
        function: "OVERVIEW", # Função para detalhes da empresa
        symbol: symbol,
        apikey: @api_key
      }
    }
    handle_response(self.class.get("/query", options))
  end

  # Obter dados financeiros (income statement, balance sheet, cash flow)
  # Documentação: https://www.alphavantage.co/documentation/#financial-statements
  def get_income_statement(symbol)
    options = {
      query: {
        function: "INCOME_STATEMENT",
        symbol: symbol,
        apikey: @api_key
      }
    }
    handle_response(self.class.get("/query", options))
  end

  # Este é o método de atalho para obter o preço atual
  def price(symbol)
    quote = get_quote(symbol)
    if quote.present? && quote["Global Quote"].present?
      quote["Global Quote"]["05. price"].to_f
    else
      nil
    end
  end

  # Novo método de atalho para obter o nome da empresa
  def company_name(symbol)
    overview = get_company_overview(symbol)
    if overview.present? && overview["Name"].present?
      overview["Name"]
    else
      nil
    end
  end

  private

  # Método para lidar com a resposta da API (sucesso, erro, limite de taxa)
  def handle_response(response)
    if response.success?
      parsed_response = response.parsed_response
      if parsed_response["Error Message"]
        Rails.logger.error "Alpha Vantage API Error for '#{response.request.uri}': #{parsed_response["Error Message"]}"
        nil
      elsif parsed_response["Note"] # Ex: Limite de requisições excedido
        Rails.logger.warn "Alpha Vantage API Note for '#{response.request.uri}': #{parsed_response["Note"]}"
        # Você pode implementar um retry ou levantar uma exceção aqui
        nil
      else
        parsed_response
      end
    else
      Rails.logger.error "HTTP Error during Alpha Vantage request '#{response.request.uri}': #{response.code} - #{response.message}"
      nil
    end
  rescue StandardError => e
    Rails.logger.error "Error parsing Alpha Vantage response for '#{response.request.uri}': #{e.message}"
    nil
  end
end
