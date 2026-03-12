require "rest_easy"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.collapse("#{__dir__}/fortnox/resources")
loader.ignore("#{__dir__}/fortnox/types")
loader.setup

module Fortnox
  extend RestEasy

  class RequestError < RestEasy::Error; end
  class AttributeError < RestEasy::Error; end

  settings do
    setting :some_relevant_setting, default: "Muuu!", reader: true
  end

  configure do
    base_url "https://api.fortnox.se/3"
    max_retries 3
    authentication RestEasy::Auth::Null.new
    attribute_convention :PascalCase
  end
end
