# frozen_string_literal: true

require 'fortnox/api/mappers/base'

module Fortnox
  module API
    module Mapper
      class DefaultDeliveryTypes < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
      end

      Registry.register(DefaultDeliveryTypes.canonical_name_sym, DefaultDeliveryTypes)
    end
  end
end
