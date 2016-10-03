require 'spec_helper'
require 'dry-struct'
require 'fortnox/api/types/model'

RSpec.describe Fortnox::API::Types::Model do
  using_test_class do
    module Types
      include Dry::Types.module

      Age = Int.constrained(gt: 18)
    end

    class TypesModelUser < Fortnox::API::Types::Model
      attribute :age, Types::Age
    end

    class DryStructUser < Dry::Struct
      attribute :age, Types::Age
    end
  end

  let(:args){ { age: 17 } }

  describe 'User inheriting directly from Dry::Struct' do
    subject{ -> { DryStructUser.new(args) } }

    it{ is_expected.to raise_error(Dry::Struct::Error) }
  end

  describe "User inheriting from #{described_class}" do
    subject{ -> { TypesModelUser.new(args) } }

    it{ is_expected.to raise_error(Dry::Struct::Error) }
  end
end
