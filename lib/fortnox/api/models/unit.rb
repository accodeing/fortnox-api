# frozen_string_literal: true

require 'fortnox/api/types'
require 'fortnox/api/models/base'

module Fortnox
  module API
    module Model
      class Unit < Fortnox::API::Model::Base
        UNIQUE_ID = :code
        STUB = { code: '' }.freeze

        # Url Direct URL to the record
        attribute :url, Types::Nullable::String.is(:read_only)

        # Comments Comments on project. 512 characters
        attribute :code, Types::Required::String.is(:read_only)

        # ContactPerson ContactPerson for project. 50 characters
        attribute :description, Types::Nullable::String
      end
    end
  end
end
