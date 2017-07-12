require "fortnox/api/repositories/base"
require "fortnox/api/models/project"
require "fortnox/api/mappers/project"

module Fortnox
  module API
    module Repository
      class Project < Fortnox::API::Repository::Base
        MODEL = Fortnox::API::Model::Project
        MAPPER = Fortnox::API::Mapper::Project
        URI = '/projects/'.freeze
      end
    end
  end
end
