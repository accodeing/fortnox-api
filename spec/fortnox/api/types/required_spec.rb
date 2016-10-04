require 'spec_helper'
require 'fortnox/api/types'
require 'fortnox/api/types/required'

describe Fortnox::API::Types::Required, type: :type do
  subject { TestClass }

  describe 'String' do
    using_test_class do
      class TestClass < Dry::Struct
        attribute :required_string, Fortnox::API::Types::Required::String
      end
    end

    it{ is_expected.to require_attribute(:required_string, String) }
  end

  describe 'Float' do
    using_test_class do
      class TestClass < Dry::Struct
        attribute :required_float, Fortnox::API::Types::Required::Float
      end
    end

    it{ is_expected.to require_attribute(:required_float, Float) }
  end
end
