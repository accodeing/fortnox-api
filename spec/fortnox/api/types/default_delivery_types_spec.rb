# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types/default_delivery_types'

RSpec.describe Fortnox::API::Types::DefaultDeliveryTypes, type: :type do
  subject { described_class }

  it { is_expected.to have_default_delivery_type(:invoice) }
  it { is_expected.to have_default_delivery_type(:order) }
  it { is_expected.to have_default_delivery_type(:offer) }
end
