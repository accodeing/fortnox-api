# frozen_string_literal: true

require 'base64'
require 'json'
require 'rest_easy'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/fortnox/resources")
loader.inflector.inflect(
  'edi_information' => 'EDIInformation'
)
loader.setup

module Fortnox
  extend RestEasy

  class RequestError < RestEasy::Error; end
  class AttributeError < RestEasy::Error; end

  OAUTH_TOKEN_URL = 'https://apps.fortnox.se/oauth-v1/token'

  class << self
    def access_token=(token)
      config.authentication = RestEasy::Auth::PSK.new(api_key: token)
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
  end
end
