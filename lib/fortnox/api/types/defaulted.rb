# frozen_string_literal: true

module Fortnox
  module API
    module Types
      module Defaulted
        String = Types::Strict::String.default('')
      end
    end
  end
end
