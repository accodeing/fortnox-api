require "fortnox/api/base"

module Fortnox
  module API
    class Repository < Fortnox::API::Base

      def initialize( options = {} )
        super()
        @base_uri = options.fetch( :base_uri ){ '/' }
        @json_list_wrapper = options.fetch( :json_list_wrapper ){ '' }
        @json_unit_wrapper = options.fetch( :json_unit_wrapper ){ '' }
        @attr_to_json_map = options.fetch( :key_map ){ {} }
        @json_to_attr_map = @attr_to_json_map.invert
      end

    private

      def convert_hash_keys_from_json_format( hash )
        hash.each_with_object( {} ) do |(key, value), json_hash|
          json_hash[ convert_key_from_json( key ) ] = value
        end
      end

      def convert_key_from_json( key )
        @json_to_attr_map.fetch( key ){ default_key_from_json_transform( key ) }
      end

      def default_key_from_json_transform( key )
        key = key.to_s
        return key.downcase if key.match(/\A[A-Z]+\z/)
        key.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z])([A-Z])/, '\1_\2').
        downcase.
        to_sym
      end

      def convert_hash_keys_to_json_format( hash )
        hash.each_with_object( {} ) do |key, value, json_hash|
          json_hash[ convert_key_to_json( key ) ] = value
        end
      end

      def convert_key_to_json( key )
        @attr_to_json_map.fetch( key ){ default_key_to_json_transform( key ) }
      end

      def default_key_to_json_transform( key )
        key.to_s.split('_').map(&:capitalize).join('')
      end

    end
  end
end
