# frozen_string_literal: true

module Fortnox
  class Unit < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path "units"
      instance_wrapper "Unit"
      collection_wrapper "Units"
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', Nullable::String, :read_only

    # Code The code of the unit.
    key :code, Strict::String

    # Description The description of the unit.
    attr :description, Nullable::String

    # TODO: new attribute
    attr :code_english, Nullable::String
  end
end
