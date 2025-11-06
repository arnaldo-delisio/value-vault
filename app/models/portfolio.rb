class Portfolio < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }

  # Helper methods
  def add_ticker(ticker)
    normalized_ticker = ticker.upcase.strip
    return if stock_tickers.include?(normalized_ticker)

    self.stock_tickers = (stock_tickers || []) + [normalized_ticker]
    save
  end

  def remove_ticker(ticker)
    normalized_ticker = ticker.upcase.strip
    self.stock_tickers = (stock_tickers || []) - [normalized_ticker]
    save
  end

  def stocks
    Stock.where(ticker: stock_tickers)
  end
end
