require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/required'

describe Fortnox::API::Types::Required, type: :type do
  subject{ TestClass }

  using_test_class do
    class TestClass < Dry::Struct
    end
  end

  shared_examples_for 'required attribute' do |type|
    it{ is_expected.to require_attribute(:required_attribute, type) }
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

    include_examples 'required attribute', Float, Fortnox::API::Types::Required::Float
  end
end
