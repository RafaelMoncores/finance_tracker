class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  validates :name, :ticker, presence: true, uniqueness: true

  def self.new_lookup(ticker_symbol)
    begin
      client = AlphaVantageClient.new
      normalized_symbol = ticker_symbol.upcase # Garante consistência

      # 1. Tenta encontrar a ação no banco de dados (para reutilizar o nome, se existir)
      # Usamos `find_or_initialize_by` para criar um novo objeto se não existir, mas não salvá-lo ainda.
      stock = find_or_initialize_by(ticker: normalized_symbol)
      price_data = client.get_quote(normalized_symbol)
      Rails.logger.debug "AlphaVantage price_data for #{normalized_symbol}: #{price_data.inspect}"

      if price_data.present? && price_data["Global Quote"].present?
        stock.last_price = price_data["Global Quote"]["05. price"].to_f
        unless stock.name.present?
          company_overview_data = client.get_company_overview(normalized_symbol)
          Rails.logger.debug "AlphaVantage company_overview_data for #{normalized_symbol}: #{company_overview_data.inspect}"

          if company_overview_data.present? && company_overview_data["Name"].present?
            stock.name = company_overview_data["Name"]
            stock.save # Salva o nome no banco de dados para futuras consultas
          else
            Rails.logger.warn "Stock.new_lookup: Company name not found for #{normalized_symbol} via API."
            # Se não encontrar o nome na API, pode deixar como nil ou definir um valor padrão
            stock.name = "N/A" # Ou deixar nil
          end
        end

        stock # Retorna o objeto Stock (existente ou recém-criado/atualizado)
      else
        Rails.logger.warn "Stock.new_lookup: Price data not found or invalid for #{normalized_symbol}. Returning nil."
        nil # Retorna nil se a busca de preço falhou
      end
    rescue => exception
      Rails.logger.error "Error looking up stock #{normalized_symbol}: #{exception.message}"
      nil # Retorna nil em caso de exceção geral
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
