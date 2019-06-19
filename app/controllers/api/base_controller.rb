module Api
  class BaseController < ApplicationController
    include Api::ErrorHandlingConcern

    private

    def current_user
      @current_user ||= find_user_by_request_api_key
    end

    def find_user_by_request_api_key
      unless user = User.find_by(api_key: request_api_key)
        raise Api::Errors::UnauthorizedRequest
      end
      user
    end

    def request_api_key
      request.headers['HTTP_X_API_KEY']
    end
  end
end