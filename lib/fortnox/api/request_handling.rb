# frozen_string_literal: true

module Fortnox
  module API
    module RequestHandling
      private

      def raise_api_error(error, response)
        message = (error['message'] || error['Message'] || 'Okänt fel')

        message += "\n\n#{response.request.inspect}" if Fortnox::API.debugging

        raise Fortnox::API::RemoteServerError, message
      end

      def validate_response(response)
        return if response.code == 200

        raise_content_type_error(response) if response.headers['content-type'].start_with?('text/html')

        raise Fortnox::API::RemoteServerError, "Unauthorized request. Error: #{response.body}" if response.code == 401
        raise Fortnox::API::RemoteServerError, "Forbidden request. Error: #{response.body}" if response.code == 403

        api_error = response.parsed_response['ErrorInformation']
        raise_api_error(api_error, response) if api_error
      end

      def raise_content_type_error(response)
        raise Fortnox::API::RemoteServerError,
              "Fortnox API's response has content type \"text/html\" instead of requested \"application/json\"." \
              'This could be due to invalid endpoint or when the API is down. ' \
              "Body: #{response.body}"
      end

      def validate_and_parse(response)
        validate_response(response)
        response.parsed_response
      end

      def execute
        response = yield(self.class)
        validate_and_parse response
      end
    end
  end
end
