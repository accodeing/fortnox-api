require "fortnox/api/repositories/base"
require "fortnox/api/models/project"
require "fortnox/api/mappers/project"

module Fortnox
  module API
    module Repository
      class Project < Repository::Base
        MODEL = Model::Project
        MAPPER = Mapper::Project
        URI = '/projects/'.freeze

        def initialize
          super(MODEL)
        end
      end
    end
  end
end
