# frozen_string_literal: true

require_relative 'base'
require_relative '../models/project'
require_relative '../mappers/project'

module Fortnox
  module API
    module Repository
      class Project < Base
        MODEL = Model::Project
        MAPPER = Mapper::Project
        URI = '/projects/'
      end
    end
  end
end
