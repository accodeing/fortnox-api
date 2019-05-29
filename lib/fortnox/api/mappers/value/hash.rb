module Fortnox
  module API
    module Mapper
      Hash = lambda do |hash|
        hash.each do |key, value|
          name = Fortnox::API::Mapper::Base.canonical_name_sym(value)
          hash[key] = Fortnox::API::Registry[name].call(value)
        end
      end

      Registry.register(:hash, Hash)
    end
  end
end
