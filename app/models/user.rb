class User < ApplicationRecord
  has_many :sleeps

  # follower friends
  has_many :followerships, class_name: 'Friendship', foreign_key: 'following_id'
  has_many :followers, through: :followerships, source: :follower

  # following friends
  has_many :followingships, class_name: 'Friendship', foreign_key: 'follower_id'
  has_many :followings, through: :followingships, source: :following

  validates :email, presence: true, uniqueness: true

  before_create :generate_api_key

  def past_week_sleeps
    self.sleeps.where(['slept_at >= ?', 7.days.ago])
  end

  private

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
