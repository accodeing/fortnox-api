require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'

shared_examples_for 'a simple mapper' do |registry_key, type|
  it{ is_expected.to be_a( Proc ) }

  describe 'Registry' do
    subject{ Fortnox::API::Registry[registry_key] }

    it 'is registered' do
      is_expected.to eq simple_mapper
    end
  end

  describe 'return value' do
    subject{ simple_mapper.call( value ) }
    it{ is_expected.to eq value }
  end
end

# describe Fortnox::API::Mapper do
#   describe 'Int' do
#     it_behaves_like 'a simple mapper', :int, Fortnox::API::Mapper::Int do
#       subject(:simple_mapper){ Fortnox::API::Mapper::Int }
#       let( :value ){ 1 }
#     end
#   end
#
#   describe 'Float' do
#     it_behaves_like 'a simple mapper', :float, Fortnox::API::Mapper::Float do
#       subject(:simple_mapper){ Fortnox::API::Mapper::Float }
#       let( :value ){ 1.0 }
#     end
#   end
#
#   describe 'String' do
#     it_behaves_like 'a simple mapper', :string, Fortnox::API::Mapper::String do
#       subject(:simple_mapper){ Fortnox::API::Mapper::String }
#       let( :value ){ 'A string' }
#     end
#   end
# end
