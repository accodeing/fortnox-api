require "fortnox/api/repositories/base"
require "fortnox/api/models/unit"
require "fortnox/api/mappers/unit"

module Fortnox
  module API
    module Repository
      class Unit < Fortnox::API::Repository::Base

        MODEL = Fortnox::API::Model::Unit
        MAPPER = Fortnox::API::Mapper::Unit
        URI = '/units/'.freeze
      end
    end
  end
end
