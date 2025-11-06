class Investor < ApplicationRecord
  # Associations
  has_many :analyses, dependent: :destroy

  # Enums
  enum persona: {
    munger: 0,
    buffett: 1,
    lynch: 2,
    graham: 3,
    dalio: 4
  }

  # Validations
  validates :name, presence: true
  validates :persona, presence: true
  validates :system_prompt, presence: true

  # Scopes
  scope :active, -> { where(active: true) }
end
