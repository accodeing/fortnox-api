# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Types::Housework do
  describe 'the tax reduction groups' do
    let(:groups) do
      [described_class::ROT_HOUSEWORK_TYPES,
       described_class::RUT_HOUSEWORK_TYPES,
       described_class::GREEN_HOUSEWORK_TYPES,
       described_class::ANY_TAX_REDUCTION_HOUSEWORK_TYPES]
    end

    # CURRENT_HOUSEWORK_TYPES is the sum of the groups, so coverage is free —
    # but a type listed in two groups would be offered under a reduction
    # Fortnox rejects it for, and would show up twice in a consumer's UI.
    it 'places each type in exactly one group' do
      expect(groups.flatten.tally.select { |_, count| count > 1 }).to be_empty
    end
  end

  describe 'HOUSEWORK_TYPES_BY_TAX_REDUCTION' do
    subject(:by_reduction) { described_class::HOUSEWORK_TYPES_BY_TAX_REDUCTION }

    it 'is keyed by the reduction types that can carry housework' do
      expect(by_reduction.keys).to contain_exactly('rot', 'rut', 'green')
    end

    it 'only lists keys the TaxReductionTypes enum accepts' do
      expect { by_reduction.each_key { |key| Fortnox::Types::TaxReductionTypes[key] } }
        .not_to raise_error
    end

    # A group added to CURRENT_HOUSEWORK_TYPES but forgotten here would leave
    # types the enum accepts that no reduction type offers.
    it 'offers every current housework type under some reduction type' do
      expect(by_reduction.values.flatten.uniq)
        .to match_array(described_class::CURRENT_HOUSEWORK_TYPES)
    end

    # OTHERCOSTS and EMPTYHOUSEWORK mark a row as not housework, so Fortnox
    # takes them whatever reduction the document declares.
    it 'offers the non-housework markers under every reduction type' do
      expect(by_reduction.values.map { |types| types & described_class::ANY_TAX_REDUCTION_HOUSEWORK_TYPES }.uniq)
        .to eq([described_class::ANY_TAX_REDUCTION_HOUSEWORK_TYPES])
    end
  end

  # The constants were public API on Fortnox::Types before they moved here,
  # and Fortnox::Types includes this module to keep them there.
  describe 'reachability through Fortnox::Types' do
    it 'exposes every constant on Fortnox::Types too' do
      expect(described_class.constants.to_h { |name| [name, Fortnox::Types.const_get(name)] })
        .to eq(described_class.constants.to_h { |name| [name, described_class.const_get(name)] })
    end
  end
end
