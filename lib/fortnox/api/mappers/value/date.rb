# frozen_string_literal: true

module Fortnox
  module API
    module Mapper
      Date = ->(value) { value.to_s }

      Registry.register(:date, Fortnox::API::Mapper::Date)
    end
  end
end
