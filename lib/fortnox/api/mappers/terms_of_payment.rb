# frozen_string_literal: true

require 'fortnox/api/mappers/base'

module Fortnox
  module API
    module Mapper
      class TermsOfPayment < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'TermsOfPayment'
        JSON_COLLECTION_WRAPPER = 'TermsOfPayments'
      end

      Registry.register(TermsOfPayment.canonical_name_sym, TermsOfPayment)
    end
  end
end
