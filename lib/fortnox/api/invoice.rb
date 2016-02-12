require "fortnox/api/models/invoice"
require "fortnox/api/repositories/invoice"
require "fortnox/api/validators/invoice"

module Fortnox
  module API
    class Invoice < Fortnox::API::Model::Invoice

      def valid?
        Fortnox::API::Validator::Invoice.validate( self )
      end

      def save
        self.class.repository.save( self )
      end

      def self.all
        repository.all
      end

      def self.find( *args )
        repository.find( *args )
      end

      def self.repository
        @repository ||= Fortnox::API::Repository::Invoice.new
      end

    end
  end
end
