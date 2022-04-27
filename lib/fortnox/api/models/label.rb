# frozen_string_literal: true

require 'fortnox/api/types'

module Fortnox
  module API
    module Model
      class Label < Model::Base
        STUB = {}.freeze

        # Id  integer, read-only. The ID of the label.
        attribute :id, Types::Required::Integer.is(:read_only)

        # Description  string, 25 characters, required. Description of the label
        attribute :description, Types::Sized::String[25].is(:read_only)
      end
    end
  end
end
