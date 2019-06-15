class User < ApplicationRecord
  has_many :sleeps

  validates :email, presence: true, uniqueness: true

  before_create :generate_api_key

  private

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
