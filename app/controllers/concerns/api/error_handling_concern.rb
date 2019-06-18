module Api
  module ErrorHandlingConcern
    extend ActiveSupport::Concern

    included do
      rescue_from Api::Errors::UnauthorizedRequest do |err|
        render json: { status: err.status, message: err.message }, status: :unauthorized
      end

      rescue_from ActionController::ParameterMissing do |err|
        render json: { status: 'error', message: err.message }, status: :bad_request
      end

      rescue_from ActiveRecord::RecordInvalid do |err|
        render json: { status: 'error', messages: err.record.errors.full_messages }, status: :bad_request
      end
    end
  end
end