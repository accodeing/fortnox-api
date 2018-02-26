# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types/invoice_row'
require 'fortnox/api/types/examples/document_row'

RSpec.describe Fortnox::API::Types::InvoiceRow, type: :type do
  subject { described_class }

  it_behaves_like 'DocumentRow', {}
end
