class Analysis < ApplicationRecord
  # Associations
  belongs_to :user, counter_cache: true
  belongs_to :stock
  belongs_to :investor, counter_cache: true

  # Enums
  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  # Validations
  validates :question, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
end
