class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :analyses, dependent: :destroy
  has_many :portfolios, dependent: :destroy

  # Enums
  enum tier: { free: 0, pro: 1, enterprise: 2 }

  # Tier limits
  def daily_analysis_limit
    case tier
    when "free" then 10
    when "pro" then Float::INFINITY
    when "enterprise" then Float::INFINITY
    end
  end

  def can_analyze?
    analyses.where("created_at > ?", 24.hours.ago).count < daily_analysis_limit
  end

  def max_concurrent_investors
    case tier
    when "free" then 2
    when "pro" then 5
    when "enterprise" then Float::INFINITY
    end
  end
end
