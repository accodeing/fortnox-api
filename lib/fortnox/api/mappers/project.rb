# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Mapper
      class Project < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'Project'
        JSON_COLLECTION_WRAPPER = 'Projects'
      end

      Registry.register(Project.canonical_name_sym, Project)
    end
  end
end
