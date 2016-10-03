require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types'

describe Fortnox::API::Types::Nullable, type: :type do
  subject{ TestStruct }

  describe 'String' do
    using_test_class do
      class TestStruct < Dry::Struct
        attribute :string, Fortnox::API::Types::Nullable::String
      end
    end

    it{ is_expected.to have_nullable(:string, 'A simple message', 0) }
  end

  describe 'Float' do
    using_test_class do
      class TestStruct < Dry::Struct
        attribute :float, Fortnox::API::Types::Nullable::Float
      end
    end

    it{ is_expected.to have_nullable(:float, 14.0, 'Not a Float!') }
  end

  describe 'Integer' do
    using_test_class do
      class TestStruct < Dry::Struct
        attribute :integer, Fortnox::API::Types::Nullable::Integer
      end
    end

    it{ is_expected.to have_nullable(:integer, 14, 14.0) }
  end

  describe 'Boolean' do
    using_test_class do
      class TestStruct < Dry::Struct
        attribute :boolean, Fortnox::API::Types::Nullable::Boolean
      end
    end

    it{ is_expected.to have_nullable(:boolean, true, 'Not a Boolean!') }
  end

  describe 'Date' do
    using_test_class do
      class TestStruct < Dry::Struct
        attribute :date, Fortnox::API::Types::Nullable::Date
      end
    end

    it{ is_expected.to have_nullable(:date, Date.new(2016, 1, 1), 'Not a Date!') }
  end
end
