require "cgi"

module Fortnox
  module API
    module Repository
      module Loaders

        def all
          response_hash = get( @base_uri )
          entities_hash = response_hash[ @json_list_wrapper ]
          entities_hash.map do |entity_hash|
            hash_to_entity( entity_hash )
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
          response_hash = get( @base_uri + id )
          entity_hash = response_hash[ @json_entity_wrapper ]
          hash_to_entity( entity_hash )
        end

        def find_all_by( hash )

        end

        def to_query( hash )
          hash.collect do |key, value|
            escape( key, value )
          end.sort * '&'
        end

        def escape( key, value )
          "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end

      end
    end
  end
end
