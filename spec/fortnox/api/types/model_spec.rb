# frozen_string_literal: true

require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types/model'

RSpec.describe Fortnox::API::Types::Model do
  shared_examples_for 'raises error' do |error|
    before do
      stub_const('Types::Age', Dry::Types['strict.int'].constrained(gt: 18).is(:required))

      types_model_user_class = Class.new(Fortnox::API::Types::Model) do
        attribute :age, Types::Age
      end

      stub_const('TypesModelUser', types_model_user_class)
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
    subject { -> { User.new } }

    before do
      stub_const('Types::Nullable::String', Dry::Types['strict.string'].optional)

      user_class = Class.new(Fortnox::API::Types::Model) do
        attribute :optional_string, Types::Nullable::String
      end

      stub_const('User', user_class)
    end

    it { is_expected.not_to raise_error }

    describe 'optional attribute' do
      subject { User.new.optional_string }

      it { is_expected.to be nil }
    end
  end
end
