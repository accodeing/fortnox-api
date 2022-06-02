# frozen_string_literal: true

require_relative 'base'
require_relative '../models/customer'
require_relative '../mappers/customer'

module Fortnox
  module API
    module Repository
      class Customer < Base
        MODEL = Model::Customer
        MAPPER = Mapper::Customer
        URI = '/customers/'
      end
    end
  end
end
