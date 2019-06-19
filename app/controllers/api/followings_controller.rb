module Api
  class FollowingsController < BaseController
    def create
      @following = User.find(params[:following][:id])
      current_user.followings << @following
      render status: :ok
    rescue ActiveRecord::RecordNotUnique
      render status: :ok
    end

    def destroy
      current_user.followingships.where(following_id: params[:id]).destroy_all
      render json: { status: 'success', message: 'Following friend record deleted'}, status: :ok
    end
  end
end