require "fortnox/api/repositories/base"
require "fortnox/api/models/invoice"
require "fortnox/api/mappers/invoice"

module Fortnox
  module API
    module Repository
      class Invoice < Fortnox::API::Repository::Base

        CONFIGURATION = superclass::Options.new( '/invoices/', 'DocumentNumber' )
        MODEL = Fortnox::API::Model::Invoice
        MAPPER = Fortnox::API::Mapper::Invoice

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
