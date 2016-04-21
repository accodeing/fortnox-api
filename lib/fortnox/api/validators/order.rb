require "fortnox/api/validators/base"
require 'fortnox/api/validators/document_base'

module Fortnox
  module API
    module Validator
      class Order < Fortnox::API::Validator::Base
        include DocumentBase
      end
    end
  end
end
