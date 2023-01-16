# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/mappers'
require 'fortnox/api/mappers/base'
require 'fortnox/api/mappers/examples/mapper'

describe Fortnox::API::Mapper::Base do
  it_behaves_like 'mapper', nil, nil, nil, check_constants: false

  shared_examples_for 'simple mapper' do |registry_key, exp_value|
    subject { mapper.call(value) }

    let(:mapper) { Fortnox::API::Registry[registry_key] }
    it { is_expected.to eq(exp_value) }
  end

  shared_examples_for 'identity mapper' do |registry_key|
    subject { mapper.call(value) }

    let(:mapper) { Fortnox::API::Registry[registry_key] }
    it { is_expected.to eq(value) }
  end

  describe 'string' do
    include_examples 'identity mapper', :string do
      let(:value) { Fortnox::API::Types::Nullable::String['test'] }
    end
  end

  describe 'int' do
    include_examples 'identity mapper', :int do
      let(:value) { Fortnox::API::Types::Nullable::Integer[1337] }
    end
  end

  describe 'integer' do
    include_examples 'identity mapper', :integer do
      let(:value) { Fortnox::API::Types::Nullable::Integer[1337] }
    end
  end

  describe 'float' do
    include_examples 'identity mapper', :float do
      let(:value) { Fortnox::API::Types::Nullable::Float[13.37] }
    end
  end

  describe 'boolean' do
    include_examples 'identity mapper', :boolean do
      let(:value) { Fortnox::API::Types::Nullable::Boolean[false] }
    end
  end

  describe 'array' do
    include_examples 'identity mapper', :array do
      let(:value) { [1, 3, 3, 7] }
    end
  end

  describe 'array with very large int (Bigint if Ruby <2.4)' do
    include_examples 'identity mapper', :array do
      let(:value) { [(100**10)] }
    end
  end

  describe 'advanced array' do
    include_examples 'simple mapper', :array, ['2016-01-01', '2016-01-02'] do
      let(:value) { [Date.new(2016, 1, 1), Date.new(2016, 1, 2)] }
    end
  end

  describe 'hash' do
    include_examples 'identity mapper', :hash do
      let(:value) { { string: 'test', int: 1337, float: 13.37 } }
    end
  end

  describe 'advanced hash' do
    expected_hash = {
      string: 'test',
      date_array: ['2016-01-01', '2016-01-02'],
      nested_hash: { date: '2016-01-03', string: 'test' }
    }
    include_examples 'identity mapper', :hash, expected_hash do
      let(:value) do
        {
          string: 'test',
          date_array: [Date.new(2016, 1, 1), Date.new(2016, 1, 2)],
          nested_hash: { date: Date.new(2016, 1, 3), string: 'test' }
        }
      end
    end
  end

  describe 'trueclass' do
    include_examples 'identity mapper', :trueclass do
      let(:value) { true }
    end
  end

  describe 'falseclass' do
    include_examples 'identity mapper', :falseclass do
      let(:value) { false }
    end
  end

  describe 'date' do
    include_examples 'simple mapper', :date, '2016-01-01' do
      let(:value) { Date.new(2016, 1, 1) }
    end
  end

  describe 'nilclass' do
    include_examples 'identity mapper', :nilclass do
      let(:value) { Fortnox::API::Types::Nullable::String[nil] }
    end
  end

  describe 'Country' do
    subject { mapper.call('GB') }

    let(:mapper) { Fortnox::API::Registry[:countrystring] }

    it { is_expected.to eq('United Kingdom') }

    describe 'special cases' do
      context 'with SE' do
        subject(:se_mapper) { mapper.call('SE') }

        it 'translates code to country name in Swedish' do
          expect(se_mapper).to eq('Sverige')
        end
      end

      context 'with nil value' do
        subject { mapper.call(nil) }

        it { is_expected.to eq(nil) }
      end

      context 'with empty string' do
        subject { mapper.call('') }

        it { is_expected.to eq('') }
      end

      context 'with nonsense' do
        subject { -> { mapper.call('nonsense') } }

        it 'is not supported (since input is sanitised) and therefore blows up' do
          raise_error(NoMethodError)
        end
      end
    end
  end
end
