# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types/order_row'
require 'fortnox/api/types/examples/document_row'

RSpec.describe Fortnox::API::Types::OrderRow, type: :type do
  valid_hash = { ordered_quantity: 10.5 }

  subject { described_class }

  it { is_expected.to require_attribute(:ordered_quantity, valid_hash) }

  it_behaves_like 'DocumentRow', valid_hash
end
