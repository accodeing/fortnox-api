# frozen_string_literal: true

require_relative 'base'

module Fortnox
  module API
    module Mapper
      class OrderRow < Fortnox::API::Mapper::Base
        KEY_MAP = {
          housework: 'HouseWork',
          housework_hours_to_report: 'HouseWorkHoursToReport',
          housework_type: 'HouseWorkType',
          vat: 'VAT'
        }.freeze
        JSON_ENTITY_WRAPPER = 'OrderRow'
        JSON_COLLECTION_WRAPPER = 'OrderRows'
      end

      Registry.register(OrderRow.canonical_name_sym, OrderRow)
      Registry.register(:orderrows, OrderRow)
    end
  end
end
