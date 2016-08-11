require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types::Sized do

  describe 'String' do
    let( :described_class ){ Fortnox::API::Types::Sized::String[ 5 ] }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with empty string' do
      let( :input ){ '' }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with fewer characters than the limit' do
      let( :input ){ 'Test' }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with more characters than the limit' do
      let( :input ){ 'Too many' }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end

  describe 'Float' do
    let( :described_class ){ Fortnox::API::Types::Sized::Float[ 0.0, 100.0 ] }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with value below the lower limit' do
      let( :input ){ -1.0 }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end

    context 'created with value at the lower limit' do
      let( :input ){ 0.0 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with valid number' do
      let( :input ){ 50.0 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with value at the upper limit' do
      let( :input ){ 100.0 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with value above the upper limit' do
      let( :input ){ 100.1 }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end

  describe 'Integer' do
    let( :described_class ){ Fortnox::API::Types::Sized::Integer[ 0, 100 ] }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with value below the lower limit' do
      let( :input ){ -1 }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end

    context 'created with value at the lower limit' do
      let( :input ){ 0 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with valid number' do
      let( :input ){ 50 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with value at the upper limit' do
      let( :input ){ 100 }
      subject{ described_class[ input ] }
      it{ is_expected.to eq input }
    end

    context 'created with value above the upper limit' do
      let( :input ){ 101 }
      subject{ -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end

end
