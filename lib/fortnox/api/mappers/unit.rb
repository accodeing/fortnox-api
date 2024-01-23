# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Mapper
      class Unit < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'Unit'
        JSON_COLLECTION_WRAPPER = 'Units'
      end

      Registry.register(Unit.canonical_name_sym, Unit)
    end
  end
end
