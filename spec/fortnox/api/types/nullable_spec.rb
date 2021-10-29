# frozen_string_literal: true

require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types'

describe Fortnox::API::Types::Nullable, type: :type do
  subject { TestStruct }

  describe 'String' do
    before do
      test_struct_class = Class.new(Dry::Struct) do
        attribute :string, Fortnox::API::Types::Nullable::String
      end

      stub_const('TestStruct', test_struct_class)
    end

    it { is_expected.to have_nullable(:string, 'A simple message', 0, '0') }
  end

  describe 'Float' do
    before do
      test_struct_class = Class.new(Dry::Struct) do
        attribute :float, Fortnox::API::Types::Nullable::Float
      end

      stub_const('TestStruct', test_struct_class)
    end

    it { is_expected.to have_nullable(:float, 14.0, 'Not a Float!', 0.0) }
  end

  describe 'Integer' do
    before do
      test_struct_class = Class.new(Dry::Struct) do
        attribute :integer, Fortnox::API::Types::Nullable::Integer
      end

      stub_const('TestStruct', test_struct_class)
    end

    it { is_expected.to have_nullable(:integer, 14, 14.0, 14) }
  end

  describe 'Boolean' do
    before do
      test_struct_class = Class.new(Dry::Struct) do
        attribute :boolean, Fortnox::API::Types::Nullable::Boolean
      end

      stub_const('TestStruct', test_struct_class)
    end

    it { is_expected.to have_nullable(:boolean, true, 'Not a Boolean!', false) }
  end

  describe 'Date' do
    before do
      test_struct_class = Class.new(Dry::Struct) do
        attribute :date, Fortnox::API::Types::Nullable::Date
      end

      stub_const('TestStruct', test_struct_class)
    end

    it { is_expected.to have_nullable_date(:date, Date.new(2016, 1, 1), 'Not a Date!') }
  end
end
