# frozen_string_literal: true

module Fortnox
  class Label < Fortnox::Resource
    attr :id, Coercible::Integer.optional, :read_only, :description, Sized::String[25]
  end
end
