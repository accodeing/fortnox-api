require "fortnox/api/repositories/base"
require "fortnox/api/models/customer"
require "fortnox/api/mappers/customer"

module Fortnox
  module API
    module Repository
      class Customer < Fortnox::API::Repository::Base

        MODEL = Fortnox::API::Model::Customer
        MAPPER = Fortnox::API::Mapper::Customer
        URI = '/customers/'.freeze
        UNIQUE_ID = 'CustomerNumber'.freeze

      end
    end
  end
end
