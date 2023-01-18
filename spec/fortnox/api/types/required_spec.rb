# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/required'

describe Fortnox::API::Types::Required, type: :type do
  before { stub_const('TestClass', Class.new(Dry::Struct)) }

  shared_examples_for 'required attribute' do |_type|
    subject { -> { TestClass.new({}) } }

    let(:error_message) do
      "[#{TestClass}.new] #{:required_attribute.inspect} is missing in Hash input"
    end

    it { is_expected.to raise_error(Dry::Struct::Error, error_message) }
  end

  describe 'String' do
    before do
      test_class = Class.new(TestClass) do
        attribute :required_attribute, Fortnox::API::Types::Required::String
      end
      stub_const('TestClass', test_class)
    end

    include_examples 'required attribute', String
  end

  describe 'Float' do
    before do
      test_class = Class.new(TestClass) do
        attribute :required_attribute, Fortnox::API::Types::Required::Float
      end
      stub_const('TestClass', test_class)
    end

    include_examples 'required attribute', Float
  end
end
