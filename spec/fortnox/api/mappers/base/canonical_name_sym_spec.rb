# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api/mappers/base/canonical_name_sym'

describe Fortnox::API::Mapper::CanonicalNameSym do
  describe '.canonical_name_sym' do
    context 'with simple class' do
      using_test_class do
        class TestClass
          extend Fortnox::API::Mapper::CanonicalNameSym
        end
      end

      subject { TestClass.canonical_name_sym }

      it { is_expected.to eq(:testclass) }
    end

    context 'when class included in module' do
      using_test_class do
        module Something
          class Test
            extend Fortnox::API::Mapper::CanonicalNameSym
          end
        end
      end

      subject { Something::Test.canonical_name_sym }

      it { is_expected.to eq(:test) }
    end
  end
end
