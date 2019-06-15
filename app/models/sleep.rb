class Sleep < ApplicationRecord
  belongs_to :user

  validates_presence_of :uuid, :slept_at, :waked_at
end
