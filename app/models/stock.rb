class Stock < ApplicationRecord
  # Associations
  has_many :analyses, dependent: :destroy

  # Validations
  validates :ticker, presence: true, uniqueness: true
  validates :ticker, format: { with: /\A[A-Z0-9.-]+\z/, message: "must be uppercase with no spaces" }

  # Callbacks
  before_validation :normalize_ticker

  # Check if cached data is stale (older than 30 minutes)
  def data_stale?
    data_fetched_at.nil? || data_fetched_at < 30.minutes.ago
  end

  private

  def normalize_ticker
    self.ticker = ticker&.upcase&.strip
  end
end
