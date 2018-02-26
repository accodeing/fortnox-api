# frozen_string_literal: true

require 'fortnox/api/types'

module Fortnox
  module API
    module Model
      class Label < Model::Base
        STUB = {}.freeze

        # Id	integer, read-only. The ID of the label.
        attribute :id, Types::Required::Integer.with(read_only: true)

        # Description	string, 25 characters, required. Description of the label
        attribute :description, Types::Sized::String[25].with(read_only: true)
      end
    end
  end
end
