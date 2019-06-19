require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it { should belong_to :user }

  context 'before saving the record' do
    let!(:user) { create(:user) }
    subject { build(:sleep, user: user) }

    it 'calculates duration in number of seconds' do
      sleep = subject
      sleep.save
      expect(sleep.duration).to eq(sleep.waked_at - sleep.slept_at)
    end
  end
end