require 'fortnox/api/types'
require 'fortnox/api/models/base'

module Fortnox
  module API
    module Model
      class Unit < Fortnox::API::Model::Base
        UNIQUE_ID = :code
        STUB = { code: '' }.freeze

        # Url Direct URL to the record
        attribute :url, Types::Nullable::String.with(read_only: true)

        # Comments Comments on project. 512 characters
        attribute :code, Types::Required::String.with(read_only: true)

        # ContactPerson ContactPerson for project. 50 characters
        attribute :description, Types::Nullable::String
      end
    end
  end
end
