# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/models/metadata'
require 'fortnox/api/models/examples/model'

describe Fortnox::API::Model::Metadata, type: :model do
  let(:required_attributes) do
    {
      current_page: 1,
      total_resources: 2,
      total_pages: 1
    }
  end

  it 'can be initialized' do
    expect { described_class.new(required_attributes) }.not_to raise_error
  end
end
