# frozen_string_literal: true

module Fortnox
  module Types
    # The housework (ROT/RUT/green) categories a document row can carry.
    #
    # Should be included in Fortnox::Types, so every constant here is also reachable
    # as `Fortnox::Types::CURRENT_HOUSEWORK_TYPES` and friends.
    module Housework
      # Which tax reduction each housework type belongs to. Fortnox enforces
      # this: a document declaring one reduction type is rejected outright if
      # it carries a row from another, with "Dokument med
      # skattereduktionstypen 'rut' får inte innehålla rader med ...".
      # Consumers building a UI need the grouping to keep users from
      # assembling a document that cannot be saved.
      ROT_HOUSEWORK_TYPES = [
        'CONSTRUCTION', 'ELECTRICITY', 'GLASSMETALWORK', 'GROUNDDRAINAGEWORK',
        'MASONRY', 'PAINTINGWALLPAPERING', 'HVAC'
      ].freeze

      RUT_HOUSEWORK_TYPES = [
        'MAJORAPPLIANCEREPAIR', 'MOVINGSERVICES', 'ITSERVICES', 'CLEANING',
        'TEXTILECLOTHING', 'SNOWPLOWING', 'GARDENING', 'BABYSITTING',
        'OTHERCARE', 'FURNISHING', 'HOMEMAINTENANCE', 'TRANSPORTATIONSERVICES',
        'WASHINGANDCAREOFCLOTHING'
      ].freeze

      GREEN_HOUSEWORK_TYPES = [
        'SOLARCELLS', 'STORAGESELFPRODUCEDELECTRICITY',
        'CHARGINGSTATIONELECTRICVEHICLE'
      ].freeze

      # Accepted under any tax reduction type. Both mark a row as not being
      # housework and must be sent with `housework` false.
      ANY_TAX_REDUCTION_HOUSEWORK_TYPES = ['OTHERCOSTS', 'EMPTYHOUSEWORK'].freeze

      # Every type Fortnox still accepts on a new document — the groups above
      # are the definition, this is only their sum. Anything added to a group
      # lands here, and in the HouseworkTypes enum, on its own.
      CURRENT_HOUSEWORK_TYPES = (
        ROT_HOUSEWORK_TYPES + RUT_HOUSEWORK_TYPES + GREEN_HOUSEWORK_TYPES +
        ANY_TAX_REDUCTION_HOUSEWORK_TYPES
      ).freeze

      # Fortnox no longer grants a reduction for these, but old documents
      # still come back carrying them, so the enum has to accept them.
      LEGACY_HOUSEWORK_TYPES = ['COOKING', 'TUTORING'].freeze

      # The types a document may carry, keyed by its tax reduction type.
      HOUSEWORK_TYPES_BY_TAX_REDUCTION = {
        'rot' => (ROT_HOUSEWORK_TYPES + ANY_TAX_REDUCTION_HOUSEWORK_TYPES).freeze,
        'rut' => (RUT_HOUSEWORK_TYPES + ANY_TAX_REDUCTION_HOUSEWORK_TYPES).freeze,
        'green' => (GREEN_HOUSEWORK_TYPES + ANY_TAX_REDUCTION_HOUSEWORK_TYPES).freeze
      }.freeze
    end
  end
end
