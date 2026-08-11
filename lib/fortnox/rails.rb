# frozen_string_literal: true

require 'fortnox'
require 'active_support/json'

# Optional Rails integration. Not loaded with the rest of the gem — require it
# explicitly, e.g. from config/initializers/fortnox.rb:
#
#   require 'fortnox/rails'
#
# Rails serialises nested objects by calling `as_json` on them. Anything that
# doesn't define it falls through to `Object#as_json`, which dumps instance
# variables — so without this, `render json: { invoices: [invoice] }` puts the
# gem's internals (`api_data`, `model_attributes`, `changes`, `meta`) in the
# response body. `to_json` needs no help here; it is correct without Rails.
module Fortnox
  # Deliberately not named `Rails`: inside `module Fortnox` that constant would
  # shadow the framework's own for every other file in the gem.
  module RailsSerialisation
    # `:only` / `:except` are applied by Fortnox::Serialisation rather than by
    # ActiveSupport, so they accept string and symbol names alike. The inner
    # `as_json` is then called without options — it only needs to stringify
    # keys and recurse into nested structs.
    module ResourceMethods
      # Same representation `to_json` produces: model attribute names.
      def as_json(options = nil)
        Serialisation.filter(model.attributes, options).as_json
      end
    end

    module StructMethods
      def as_json(options = nil)
        Serialisation.filter(to_h, options).as_json
      end
    end

    module CollectionMethods
      def as_json(options = nil)
        to_a.map { |item| item.as_json(options) }
      end
    end
  end
end

Fortnox::Resource.include(Fortnox::RailsSerialisation::ResourceMethods)
Fortnox::Struct.include(Fortnox::RailsSerialisation::StructMethods)
Fortnox::Collection.include(Fortnox::RailsSerialisation::CollectionMethods)
