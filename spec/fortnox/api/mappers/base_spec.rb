require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base do
  it_behaves_like 'mapper', nil, nil, nil, check_constants: false

  describe '#canonical_name_sym' do
    subject{ described_class.canonical_name_sym }
    it{ is_expected.to eq( described_class.name.split( '::' ).last.to_sym ) }
  end
end
