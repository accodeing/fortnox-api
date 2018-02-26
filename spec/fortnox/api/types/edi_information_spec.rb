# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types/edi_information'

RSpec.describe Fortnox::API::Types::EDIInformation, type: :type do
  subject { described_class }

  it { is_expected.to have_nullable_string(:edi_global_location_number) }
  it { is_expected.to have_nullable_string(:edi_global_location_number_delivery) }
  it { is_expected.to have_nullable_string(:edi_invoice_extra1) }
  it { is_expected.to have_nullable_string(:edi_invoice_extra2) }
  it { is_expected.to have_nullable_string(:edi_our_electronic_reference) }
  it { is_expected.to have_nullable_string(:edi_your_electronic_reference) }
end
