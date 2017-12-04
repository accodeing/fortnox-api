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
        self.class.base_uri( get_base_url )

        self.headers = DEFAULT_HEADERS.merge({
          'Client-Secret' => get_client_secret,
        })
      end

      def config
        Fortnox::API.config
      end

      def get_access_token( store_name )
        @access_tokens ||= CircularQueue.new( *load_access_tokens( store_name ))
        @access_tokens.next
      end

      def check_access_tokens!( tokens )
        if tokens == nil or tokens.length.zero?
          fail MissingConfiguration, "You have not provided any access token(s) in the given store."
        end
      end

      def load_access_tokens( store_name )
        begin
          tokens = config.token_store.fetch( store_name )
        rescue KeyError
          fail MissingConfiguration, "Store #{store_name.inspect} is not present in token store."
        end

        check_access_tokens!( tokens )
        tokens
      end

      def get_base_url
        base_url = config.base_url
        fail MissingConfiguration, 'You have to provide a base url.' unless base_url
        base_url
      end

      def get_client_secret
        client_secret = config.client_secret
        fail MissingConfiguration, 'You have to provide your client secret.' unless client_secret
        client_secret
      end

      HTTP_METHODS.each do |method|
        define_method method do |*args, token_store:|
          self.headers['Access-Token'] = get_access_token(token_store)
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
