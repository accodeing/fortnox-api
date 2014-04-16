require "fortnox/api/class_methods"
require "fortnox/api/instance_methods"
require "httparty"

module Fortnox
  module API
    class Base

      include HTTParty
      extend Fortnox::API::ClassMethods
      include Fortnox::API::InstanceMethods

    end
  end
end