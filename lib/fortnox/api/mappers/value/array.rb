# frozen_string_literal: true

module Fortnox
  module API
    module Mapper
      Array = lambda do |array|
        array.each_with_object([]) do |item, converted_array|
          name = Fortnox::API::Mapper::Base.canonical_name_sym(item)
          converted_array << Fortnox::API::Registry[name].call(item)
        end
      end

      Registry.register(:array, Fortnox::API::Mapper::Array)

      Registry.register(:labels, Fortnox::API::Mapper::Array)
    end
  end
end
