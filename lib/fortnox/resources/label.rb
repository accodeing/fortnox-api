# frozen_string_literal: true

module Fortnox
  class Label < Fortnox::Resource
    configure do
      path 'labels'
      instance_wrapper 'Label'
      collection_wrapper 'Labels'
      scope 'settings'
    end

    attr :id, Coercible::Integer.optional, :read_only, :key
    attr :description, Sized::String[25]
  end
end
