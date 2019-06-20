require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  it { should have_many :sleeps }
  it { should have_many :followerships }
  it { should have_many :followers }
  it { should have_many :followingships }
  it { should have_many :followings }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }

  context 'add followers' do
    let!(:follower) { create(:user, name: 'Follower') }

    it 'becomes following of the follower' do
      user.followers << follower
      expect(follower.followings).to include(user)
    end
  end

  context 'add followings' do
    let!(:following) { create(:user, name: 'Following') }

    it 'becomes follower of the following' do
      user.followings << following
      expect(following.followers).to include(user)
    end
  end

  context 'before creating the record' do
    let(:user) { build(:user) }

    it 'generates api_key for the user' do
      expect(user.api_key).to be_blank
      user.save
      expect(user.api_key).to_not be_blank
    end
  end

  describe '#past_week_sleeps' do
    let!(:last_month_sleep) { create(:sleep, user: user, slept_at: 1.month.ago, waked_at: 1.month.ago + 8.hour) }
    let!(:past_week_sleep) { create(:sleep, user: user, slept_at: 1.week.ago + 1.minute, waked_at: 1.week.ago + 8.hour) }

    it 'returns sleep records only in past week' do
      expect(user.past_week_sleeps.to_a).to_not include(last_month_sleep)
      expect(user.past_week_sleeps.to_a).to include(past_week_sleep)
    end
  end
end
