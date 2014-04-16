require "fortnox/api/version"
require "fortnox/api/base"

module Fortnox
  module API

  	class << self
  		extend Forwardable
  		delegate [ :new, :get_access_token ] => Fortnox::API::Base
  	end

  end
end

