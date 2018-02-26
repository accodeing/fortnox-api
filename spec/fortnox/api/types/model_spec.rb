# frozen_string_literal: true

require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types/model'

RSpec.describe Fortnox::API::Types::Model do
  shared_examples_for 'raises error' do |error|
    using_test_classes do
      module Types
        include Dry::Types.module

        Age = Int.constrained(gt: 18).with(required: true)
      end

      class TypesModelUser < Fortnox::API::Types::Model
        attribute :age, Types::Age
      end
    end

    describe "User inheriting from #{described_class}" do
      subject { -> { TypesModelUser.new(args) } }

      it { is_expected.to raise_error(error) }
    end
  end

  context 'without required keys' do
    include_examples 'raises error', Fortnox::API::MissingAttributeError do
      let(:args) { {} }
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

    subject { -> { User.new } }

    it { is_expected.not_to raise_error }

    describe 'optional attribute' do
      subject { User.new.optional_string }

      it { is_expected.to be nil }
    end
  end
end
