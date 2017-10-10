require 'fortnox/api/request_handling'
require 'httparty'

module Fortnox
  module API
    class Base

      include HTTParty
      include Fortnox::API::RequestHandling

      HTTParty::Parser::SupportedFormats[ "text/html" ] = :json

      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }.freeze

      HTTP_METHODS = [ :get, :put, :post, :delete ].freeze

      attr_accessor :headers

      def initialize
        self.class.base_uri( Fortnox::API.get_base_url )

        self.headers = DEFAULT_HEADERS.merge({
          'Client-Secret' => Fortnox::API.get_client_secret,
        })
      end

      HTTP_METHODS.each do |method|
        define_method method do |*args|
          self.headers['Access-Token'] = Fortnox::API.get_access_token
          execute do |remote|
            remote.send( method, *args )
          end
        end
      end

      def self.set_headers( headers = {} )
        self.headers.merge!( headers )
      end

    end
  end
end
