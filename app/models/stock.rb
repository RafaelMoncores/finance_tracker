class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    begin
      client = AlphaVantageClient.new

      # Tenta buscar os dados da cotação
      price_data = client.get_quote(ticker_symbol)

      # Tenta buscar os dados do overview da empresa
      company_overview_data = client.get_company_overview(ticker_symbol)

      if price_data.present? && price_data["Global Quote"].present?
        # Extrai o preço
        last_price = price_data["Global Quote"]["05. price"].to_f
        # Extrai o ticker (se houver, caso contrário usa o que foi passado)
        ticker = price_data["Global Quote"]["01. symbol"] || ticker_symbol.upcase
        # Extrai o nome da empresa, se disponível
        company_name = company_overview_data["Name"] if company_overview_data.present? && company_overview_data["Name"].present?

        # Cria um novo objeto Stock (sem salvar no banco de dados ainda)
        new(ticker: ticker, last_price: last_price, name: company_name)
      else
        nil # Retorna nil se a busca de preço falhou ou não encontrou dados válidos
      end
    rescue => e
      Rails.logger.error "Error looking up stock #{ticker_symbol}: #{e.message}"
      nil # Retorna nil em caso de exceção geral
    end
  end
end
