class Sleep < ApplicationRecord
  belongs_to :user

  validates :uuid, format: { with: Utilities.uuid_regex, message: 'must be a uuid string' }
  validates_each :slept_at, :waked_at do |record, attr, value|
    error = DateTime.parse(value.to_s) rescue ArgumentError
    record.errors.add(attr, 'must be a date-time string') if error == ArgumentError
  end

  before_save :calculate_duration

  private

  def calculate_duration
    self.duration = waked_at - slept_at
  end
end
