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

end
