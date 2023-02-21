# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/mappers/base/canonical_name_sym'

describe Fortnox::API::Mapper::CanonicalNameSym do
  describe '.canonical_name_sym' do
    context 'with simple class' do
      subject { TestClass.canonical_name_sym }

      before do
        test_class = Class.new do
          extend Fortnox::API::Mapper::CanonicalNameSym
        end

        stub_const('TestClass', test_class)
      end

      it { is_expected.to eq(:testclass) }
    end

    context 'when class included in module' do
      subject { Something::Test.canonical_name_sym }

      before do
        test_class = Class.new do
          extend Fortnox::API::Mapper::CanonicalNameSym
        end

        stub_const('Something::Test', test_class)
      end

      it { is_expected.to eq(:test) }
    end
  end
end
