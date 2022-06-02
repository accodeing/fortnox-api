# frozen_string_literal: true

require_relative 'base'
require_relative '../models/invoice'
require_relative '../mappers/invoice'

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
