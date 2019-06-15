class Sleep < ApplicationRecord
  belongs_to :user

  validates_presence_of :uuid, :slept_at, :waked_at

  before_save :calculate_duration

  private

  def calculate_duration
    self.duration = waked_at - slept_at
  end
end
