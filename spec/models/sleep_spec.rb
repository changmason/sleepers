require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :uuid }
  it { should validate_presence_of :slept_at }
  it { should validate_presence_of :waked_at }


end