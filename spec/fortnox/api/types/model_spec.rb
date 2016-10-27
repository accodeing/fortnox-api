require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types/model'

RSpec.describe Fortnox::API::Types::Model do
  shared_examples_for 'raises error' do |dry_error, fortnox_api_error|
    using_test_classes do
      module Types
        include Dry::Types.module

        Age = Int.constrained(gt: 18)
      end

      class DryStructUser < Dry::Struct
        attribute :age, Types::Age
      end

      class TypesModelUser < Fortnox::API::Types::Model
        attribute :age, Types::Age
      end
    end

    describe 'User inheriting directly from Dry::Struct' do
      subject{ ->{ DryStructUser.new(args) } }

      it{ is_expected.to raise_error(dry_error) }
    end

    describe "User inheriting from #{ described_class }" do
      subject{ ->{ TypesModelUser.new(args) } }

      it{ is_expected.to raise_error(fortnox_api_error) }
    end
  end

  context 'with invalid argument' do
    include_examples 'raises error', Dry::Struct::Error, Fortnox::API::InvalidAttributeValueError do
      let(:args){ { age: 17 } }
    end
  end

  context 'without required keys' do
    include_examples 'raises error', Dry::Struct::Error, Fortnox::API::MissingAttributeError do
      let(:args){ {} }
    end
  end

  context 'when omitting optional keys' do
    using_test_class do
      module Types
        include Dry::Types.module

        module Nullable
          String = Types::Strict::String.optional
        end
      end

      class User < Fortnox::API::Types::Model
        attribute :optional_string, Types::Nullable::String
      end
    end

    subject{ ->{ User.new() } }

    it{ is_expected.not_to raise_error }

    describe 'optional attribute' do
      subject{ User.new().optional_string }
      it{ is_expected.to be nil }
    end
  end
end
