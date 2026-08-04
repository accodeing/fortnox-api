# frozen_string_literal: true

module Fortnox
  class Unit < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'units'
      instance_wrapper 'Unit'
      collection_wrapper 'Units'
      scope 'settings'
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', UnsizedString, :read_only

    # Code The code of the unit.
    key :code, Sized::String[20], :required

    # Description The description of the unit.
    attr :description, Sized::String[100], :required

    # CodeEnglish English code of the unit
    attr :code_english, Sized::String[100]
  end
end
