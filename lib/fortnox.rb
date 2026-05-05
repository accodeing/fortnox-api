# frozen_string_literal: true

require 'base64'
require 'json'
require 'rest_easy'
require 'zeitwerk'

module Fortnox
  @loader = Zeitwerk::Loader.for_gem
  @loader.collapse("#{__dir__}/fortnox/resources")
  @loader.inflector.inflect(
    'edi_information' => 'EDIInformation'
  )
  @loader.setup

  extend RestEasy

  class Error < StandardError; end

  class RequestError < Error
    attr_reader :response

    def initialize(arg = nil)
      if arg.respond_to?(:status)
        @response = arg
        super("Request failed: #{arg.status}")
      else
        super
      end
    end
  end

  class AttributeError < Error; end

  class ConstraintError < AttributeError
    attr_reader :attribute_name, :value

    def initialize(attribute_name, value, message = nil)
      @attribute_name = attribute_name
      @value = value
      super(message || "Constraint violation for attribute '#{attribute_name}' with value: #{value.inspect}")
    end
  end

  class MissingAttributeError < AttributeError
    attr_reader :attribute_name

    def initialize(attribute_name)
      @attribute_name = attribute_name
      super("Missing required attribute: #{attribute_name}")
    end
  end

  class MissingAccessToken < Error; end

  OAUTH_TOKEN_URL = 'https://apps.fortnox.se/oauth-v1/token'

  class << self
    def access_token=(token)
      Thread.current[Auth::ThreadLocal::THREAD_LOCAL_KEY] = token
    end

    def access_token
      Thread.current[Auth::ThreadLocal::THREAD_LOCAL_KEY]
    end

    def request_access_token(client_id:, client_secret:, tenant_id:, scopes: nil)
      response = token_request(client_id, client_secret, tenant_id, scopes)
      parsed = JSON.parse(response.body)

      unless response.success?
        error = parsed['error_description'] || parsed['error'] || response.body
        raise RequestError, "Token request failed (#{response.status}): #{error}"
      end

      parsed['access_token']
    end

    def scopes
      @loader.eager_load
      Resource.registered_resources
              .group_by(&:scope)
              .reject { |scope, _| scope.nil? }
              .sort
              .to_h
    end

    private

    def token_request(client_id, client_secret, tenant_id, scopes)
      credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")
      body = { grant_type: 'client_credentials' }
      body[:scope] = scopes if scopes

      Faraday.post(OAUTH_TOKEN_URL) do |req|
        req.headers['Authorization'] = "Basic #{credentials}"
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.headers['Accept'] = 'application/json'
        req.headers['TenantId'] = tenant_id.to_s
        req.body = URI.encode_www_form(body)
      end
    end
  end

  configure do
    base_url 'https://api.fortnox.se/3'
    max_retries 3
    attribute_convention :PascalCase
    authentication Auth::ThreadLocal.new
  end
end
