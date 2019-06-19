module Api
  class SleepsController < BaseController
    def upsert
      @sleep = current_user.sleeps.find_or_initialize_by(uuid: params[:uuid])
      @sleep.attributes = sleep_params
      @sleep.save!
    end

    def index
      @sleeps = current_user.sleeps.order(:created_at)
    end

    private

    def sleep_params
      params.require(:sleep).permit(:slept_at, :waked_at)
    end
  end
end