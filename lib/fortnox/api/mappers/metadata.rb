# frozen_string_literal: true

require 'fortnox/api/mappers/base'

module Fortnox
  module API
    module Mapper
      class Metadata < Fortnox::API::Mapper::Base
        KEY_MAP = {
          total_resources: '@TotalResources',
          total_pages: '@TotalPages',
          current_page: '@CurrentPage'
        }.freeze
        JSON_ENTITY_WRAPPER = 'MetaInformation'
      end

      Registry.register(Metadata.canonical_name_sym, Metadata)
    end
  end
end
