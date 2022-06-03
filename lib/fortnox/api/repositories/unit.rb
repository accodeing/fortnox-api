# frozen_string_literal: true

require_relative 'base'
require_relative '../models/unit'
require_relative '../mappers/unit'

module Fortnox
  module API
    module Repository
      class Unit < Fortnox::API::Repository::Base
        MODEL = Fortnox::API::Model::Unit
        MAPPER = Fortnox::API::Mapper::Unit
        URI = '/units/'
      end
    end
  end
end
