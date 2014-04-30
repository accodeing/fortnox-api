require "fortnox/api/repository"

module Fortnox
  module API
    module Customer
      class Repository < Fortnox::API::Repository

        def initialize
          super(
            base_uri: '/customers/',
            json_list_wrapper: 'Customers',
            json_unit_wrapper: 'Customer',
            key_map: {
              vat_type: "VATType",
            }
          )
        end

        def all
          customers_hash = get( @base_uri )
          customers_hash[ @json_list_wrapper ].map do |customer_hash|
            hash_to_customer( customer_hash )
          end
        end

        def find( id_or_hash )
          return find_all_by( id_or_hash ) if id_or_hash.is_a? Hash

          id = Integer( id_or_hash )
          find_one_by( id )

        catch ArgumentError
          raise ArgumentError, "find only accepts a number or hash as argument"
        end

        def find_one_by( id )
          customer_hash = get( @base_uri + id )
          hash_to_customer( customer_hash[ @json_unit_wrapper ] )
        end

        def find_all_by( hash )

        end

        def save( customer )
          customer_to_hash( customer )
        end

      private

        def hash_to_customer( customer_json_hash )
          customer_hash = convert_hash_keys_from_json_format( customer_json_hash )
          Fortnox::API::Customer::Entity.new( customer_hash )
        end

        def customer_to_hash( customer )
          customer_hash = customer.to_hash
          customer_json_hash = convert_hash_keys_to_json_format( customer_hash )
          { @json_unit_wrapper => converted_customer_hash }
        end

      end
    end
  end
end
