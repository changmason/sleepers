module Api
  class FollowingsController < BaseController
    def create
      @following = User.find(params[:following][:id])
      current_user.followings << @following
      render status: :ok
    rescue ActiveRecord::RecordNotUnique
      render status: :ok
    end
  end
end