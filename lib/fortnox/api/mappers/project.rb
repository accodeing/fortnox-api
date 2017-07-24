require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class Project < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'Project'.freeze
        JSON_COLLECTION_WRAPPER = 'Projects'.freeze
      end

      Registry.register( Project.canonical_name_sym, Project )
    end
  end
end
