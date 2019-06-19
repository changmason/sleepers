module Api
  class FriendSleepsController < BaseController
    def index
      friendship = Friendship.find_by!(follower_id: current_user.id, following_id: params[:id])
      @sleeps = friendship.following.past_week_sleeps.order(duration: :desc)
      render status: :ok
    end
  end
end