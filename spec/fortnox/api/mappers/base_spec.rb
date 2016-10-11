require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base, focus: true do
  #it_behaves_like 'mapper', nil, nil, nil, check_constants: false

  describe 'string' do
    let( :mapper ){ Fortnox::API::Registry[ :string ]}
    subject{ mapper.call( Fortnox::API::Types::Nullable::String[ 'test' ] )}
    it{ is_expected.to eq( '"test"' )}
  end

  describe 'int' do
    let( :mapper ){ Fortnox::API::Registry[ :int ]}
    subject{ mapper.call( Fortnox::API::Types::Nullable::Integer[ 1337 ] )}
    it{ is_expected.to eq( 1337 )}
  end

  describe 'float' do
    let( :mapper ){ Fortnox::API::Registry[ :float ]}
    subject{ mapper.call( Fortnox::API::Types::Nullable::Float[ 13.37 ] )}
    it{ is_expected.to eq( 13.37 )}
  end

  describe 'boolean' do
    let( :mapper ){ Fortnox::API::Registry[ :boolean ]}
    subject{ mapper.call( Fortnox::API::Types::Nullable::Boolean[ false ] )}
    it{ is_expected.to eq( '"false"' )}
  end

  describe 'array' do
    let( :mapper ){ Fortnox::API::Registry[ :array ]}
    subject{ mapper.call( [1,3,3,7] )}
    it{ is_expected.to eq( '[1,3,3,7]' )}
  end

  describe 'hash' do
    let( :mapper ){ Fortnox::API::Registry[ :hash ]}
    subject{ mapper.call( { string: 'test', int: 1337, float: 13.37 } )}
    it{ is_expected.to eq( '{"string":"test","int":1337,"float":13.37}' )}
  end

  describe 'advanced hash' do
    let( :mapper ){ Fortnox::API::Registry[ :hash ]}
    subject{ mapper.call( { string: 'test', int_array: [1,3,3,7], nested_hash:{ float: 13.37 }} )}
    it{ is_expected.to eq( '{"string":"test","int_array":[1,3,3,7],"nested_hash":{"float":13.37}}' )}
  end

  describe '#canonical_name_sym' do
    subject{ described_class.canonical_name_sym }
    it{ is_expected.to eq( described_class.name.split( '::' ).last.downcase.to_sym ) }
  end
end
