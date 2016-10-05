require 'fortnox/api/class_methods'
require 'fortnox/api/environment_validation'
require 'fortnox/api/request_handling'
require 'httparty'

module Fortnox
  module API
    class Base

      include HTTParty
      extend Fortnox::API::ClassMethods
      include Fortnox::API::EnvironmentValidation
      include Fortnox::API::RequestHandling

      HTTParty::Parser::SupportedFormats[ "text/html" ] = :json

      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }

      HTTP_METHODS = [ :get, :put, :post, :delete ]

      attr_accessor :headers

      def initialize
        self.class.base_uri( get_base_url )

        self.headers = DEFAULT_HEADERS.merge({
          'Client-Secret' => get_client_secret,
          'Access-Token' => get_access_token,
        })
      end

      HTTP_METHODS.each do |method|
        define_method method do |*args|
          execute do |remote|
            response = remote.send( method, *args )
            self.headers['Access-Token'] = get_access_token
            return response
          end
        end
      end

    end
  end
end
