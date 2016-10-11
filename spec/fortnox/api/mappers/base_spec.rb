require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base do
  it_behaves_like 'mapper', nil, nil, nil, check_constants: false

  shared_examples_for 'simple mapper' do |registry_key, exp_value|
    let( :mapper ){ Fortnox::API::Registry[ registry_key ]}
    subject{ mapper.call( value )}
    it{ is_expected.to eq( exp_value )}
  end

  describe 'string' do
    include_examples 'simple mapper', :string, '"test"' do
      let( :value ){ Fortnox::API::Types::Nullable::String[ 'test' ] }
    end
  end

  describe 'int' do
    include_examples 'simple mapper', :int, 1337 do
      let( :value ){ Fortnox::API::Types::Nullable::Integer[ 1337 ] }
    end
  end

  describe 'float' do
    include_examples 'simple mapper', :float, 13.37 do
      let( :value ){ Fortnox::API::Types::Nullable::Float[ 13.37 ] }
    end
  end

  describe 'boolean' do
    include_examples 'simple mapper', :boolean, '"false"' do
      let( :value ){ Fortnox::API::Types::Nullable::Boolean[ false ] }
    end
  end

  describe 'array' do
    include_examples 'simple mapper', :array, '[1,3,3,7]' do
      let( :value ){ [1,3,3,7] }
    end
  end

  describe 'hash' do
    include_examples 'simple mapper', :hash, '{"string":"test","int":1337,"float":13.37}' do
      let( :value ){ { string: 'test', int: 1337, float: 13.37 } }
    end
  end

  describe 'advanced hash' do
    include_examples 'simple mapper',
                     :hash,
                     '{"string":"test","int_array":[1,3,3,7],"nested_hash":{"float":13.37}}' do
      let( :value ){ { string: 'test', int_array: [1,3,3,7], nested_hash:{ float: 13.37 } } }
    end
  end

  describe '#canonical_name_sym' do
    subject{ described_class.canonical_name_sym }
    it{ is_expected.to eq( described_class.name.split( '::' ).last.downcase.to_sym ) }
  end
end
