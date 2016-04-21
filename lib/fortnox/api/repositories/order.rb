require "fortnox/api/repositories/base"
require "fortnox/api/models/order"

module Fortnox
  module API
    module Repository
      class Order < Fortnox::API::Repository::Base

        CONFIGURATION = Fortnox::API::Repository::Base::Options.new(
          uri: '/orders/',
          json_collection_wrapper: 'Orders',
          json_entity_wrapper: 'Order',
          unique_id: 'DocumentNumber',
          attribute_name_to_json_key_map: {
            administration_fee_vat: 'AdministrationFeeVAT',
            edi_information: 'EDIInformation',
            freight_vat: 'FreightVAT',
            total_vat: 'TotalVAT',
            vat_included: 'VATIncluded'
          },
          keys_filtered_on_save: [
            :url,
          ]
        )
        MODEL = Fortnox::API::Model::Order

        def initialize
          super( CONFIGURATION )
        end
      end
    end
  end
end
