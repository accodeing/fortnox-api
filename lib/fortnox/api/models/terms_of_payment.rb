# frozen_string_literal: true

require 'fortnox/api/types'
require 'fortnox/api/models/base'

module Fortnox
  module API
    module Model
      class TermsOfPayment < Fortnox::API::Model::Base
        UNIQUE_ID = :code
        STUB = { code: '', description: '' }.freeze

        # Direct URL to the record
        attribute :url, Types::Nullable::String.with(read_only: true)

        # The code of the term of payment. Sortable
        # TODO: Only writable during POST.
        # TODO: Must be alphanumeric
        # TODO: 30days is a valid value, but the API rewrites it as 30DAYS
        #       and you will not find the resource with a GET with value '30days'
        attribute :code, Types::Required::String

        # The description of the term of payment
        attribute :description, Types::Required::String
      end
    end
  end
end
