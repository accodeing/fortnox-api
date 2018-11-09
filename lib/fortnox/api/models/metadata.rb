# frozen_string_literal: true

require 'fortnox/api/types'

module Fortnox
  module API
    module Model
      class Metadata < Model::Base
        STUB = {
          current_page: '',
          total_resources: '',
          total_pages: ''
        }.freeze

        attribute :current_page, Types::Required::Integer.is(:read_only)
        attribute :total_resources, Types::Required::Integer.is(:read_only)
        attribute :total_pages, Types::Required::Integer.is(:read_only)
      end
    end
  end
end
