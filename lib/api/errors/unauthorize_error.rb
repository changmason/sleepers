module Api
  module Errors
    class UnauthorizeError < StandardError
      def status
        'error'
      end

      def message
        'Unauthorized request, please provide a valid api-key'
      end
    end
  end
end