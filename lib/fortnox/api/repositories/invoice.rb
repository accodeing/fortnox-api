require "fortnox/api/repositories/base"
require "fortnox/api/models/invoice"
require "fortnox/api/mappers/invoice"

module Fortnox
  module API
    module Repository
      class Invoice < Fortnox::API::Repository::Base
        MODEL = Fortnox::API::Model::Invoice
        MAPPER = Fortnox::API::Mapper::Invoice
        URI = '/invoices/'.freeze

        def initialize
          super(MODEL)
        end
      end
    end
  end
end
