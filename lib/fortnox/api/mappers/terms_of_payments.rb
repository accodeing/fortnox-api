require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class TermsOfPayments < Fortnox::API::Mapper::Base
        KEY_MAP = {}.freeze
        JSON_ENTITY_WRAPPER = 'TermsOfPayment'.freeze
        JSON_COLLECTION_WRAPPER = 'TermsOfPayments'.freeze
      end

      Registry.register( TermsOfPayments.canonical_name_sym, TermsOfPayments )
    end
  end
end
