require "fortnox/api/mappers/base"

module Fortnox
  module API
    module Mapper
      class EmailInformation < Fortnox::API::Mapper::Base

        KEY_MAP = {
          email_address_bcc: 'EmailAddressBCC',
          email_address_cc: 'EmailAddressCC'
        }.freeze
        JSON_ENTITY_WRAPPER = JSON_COLLECTION_WRAPPER = 'EmailInformation'.freeze
      end

      Registry.register( EmailInformation.canonical_name_sym, EmailInformation )
    end
  end
end
