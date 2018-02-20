# frozen_string_literal: true

require 'fortnox/api/repositories/base'
require 'fortnox/api/models/invoice'
require 'fortnox/api/mappers/invoice'

module Fortnox
  module API
    module Repository
      class Invoice < Base
        MODEL = Model::Invoice
        MAPPER = Mapper::Invoice
        URI = '/invoices/'
      end
    end
  end
end
