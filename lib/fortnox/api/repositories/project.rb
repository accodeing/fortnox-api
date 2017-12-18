require "fortnox/api/repositories/base"
require "fortnox/api/models/project"
require "fortnox/api/mappers/project"

module Fortnox
  module API
    module Repository
      class Project < Base
        MODEL = Model::Project
        MAPPER = Mapper::Project
        URI = '/projects/'.freeze
      end
    end
  end
end
