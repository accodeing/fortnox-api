require "fortnox/api/repositories/base"
require "fortnox/api/models/customer"
require "fortnox/api/mappers/customer"

module Fortnox
  module API
    module Repository
      class Customer < Fortnox::API::Repository::Base

        CONFIGURATION = superclass::Options.new( '/customers/', 'CustomerNumber' )
        MODEL = Fortnox::API::Model::Customer
        MAPPER = Fortnox::API::Mapper::Customer

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
