# frozen_string_literal: true

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

  class << self
    def access_token=(token)
      config.authentication = RestEasy::Auth::PSK.new(api_key: token)
    end
  end

  configure do
    base_url 'https://api.fortnox.se/3'
    max_retries 3
    attribute_convention :PascalCase
  end
end
