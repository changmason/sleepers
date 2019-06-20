require 'rails_helper'

RSpec.describe Sleep, type: :model do
  it { should belong_to :user }

  context 'validations' do
    let!(:user) { create(:user) }
    let(:sleep) { build(:sleep, user: user) }

    it 'validates uuid as uuid string' do
      sleep.uuid = 'invalid-form'
      expect(sleep).to be_invalid
      expect(sleep.errors[:uuid]).to eq(['must be a uuid string'])
    end

    it 'validates slept_at as date-time string' do
      sleep.slept_at = 'not-a-date-time'
      expect(sleep).to be_invalid
      expect(sleep.errors[:slept_at]).to eq(['must be a date-time string'])
    end

    it 'validates waked_at as date-time string' do
      sleep.waked_at = 'not-a-date-time'
      expect(sleep).to be_invalid
      expect(sleep.errors[:waked_at]).to eq(['must be a date-time string'])
    end
  end

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