require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/required'

describe Fortnox::API::Types::Required, type: :type do
  using_test_class do
    class TestClass < Dry::Struct
    end
  end

  shared_examples_for 'required attribute' do |type|
    subject{ -> { TestClass.new({}) } }

    let(:error_message) do
      "[#{ TestClass }.new] #{ :required_attribute.inspect } is missing in Hash input"
    end

    it 'raises an error' do
      is_expected.to raise_error(Dry::Struct::Error, error_message)
    end
  end

  describe 'String' do
    before do
      class TestClass
        attribute :required_attribute, Fortnox::API::Types::Required::String
      end
    end

    include_examples 'required attribute', String
  end

  describe 'Float' do
    before do
      class TestClass
        attribute :required_attribute, Fortnox::API::Types::Required::Float
      end
    end

    include_examples 'required attribute', Float
  end
end
