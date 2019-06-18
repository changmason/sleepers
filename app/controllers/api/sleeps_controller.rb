module Api
  class SleepsController < ApplicationController
    rescue_from Api::Errors::UnauthorizeError do |err|
      render json: { status: err.status, message: err.message }, status: :unauthorized
    end

    rescue_from ActionController::ParameterMissing do |err|
      render json: { status: 'error', message: err.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordInvalid do |err|
      render json: { status: 'error', messages: err.record.errors.full_messages }, status: :bad_request
    end

    def upsert
      @sleep = current_user.sleeps.find_or_initialize_by(uuid: params[:uuid])
      @sleep.attributes = sleep_params
      @sleep.save!
      render status: :ok
    end

    private

    def current_user
      @current_user ||= find_user_by_request_api_key
    end

    def find_user_by_request_api_key
      unless user = User.find_by(api_key: request_api_key)
        raise Api::Errors::UnauthorizeError
      end
      user
    end

    def request_api_key
      request.headers['HTTP_X_API_KEY']
    end

    def sleep_params
      params.require(:sleep).permit(:slept_at, :waked_at)
    end
  end
end