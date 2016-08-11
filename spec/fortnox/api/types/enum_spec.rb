require 'spec_helper'
require 'fortnox/api/types'

describe Fortnox::API::Types do
  describe 'CountryCode' do

    # TODO(Hannes): This can be pulled out as examples and then run for every
    # enum type we have. I'm just not as good at that as you are :)
    let( :described_class ){ Fortnox::API::Types::CountryCode }

    context 'created with nil' do
      subject{ described_class[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with a random member from the CountryCodes enum' do
      let( :enum_value ){ Fortnox::API::Types::CountryCodes.values.sample }
      subject{ described_class[ enum_value ] }
      it{ is_expected.to eq enum_value }
    end

    context 'created with a symoblised, random member from the CountryCodes enum' do
      let( :enum_value ){ Fortnox::API::Types::CountryCodes.values.sample }
      let( :input ){ enum_value.to_sym }
      subject{ described_class[ input ] }
      it{ is_expected.to eq enum_value }
    end

    context 'created with a lower case, random member from the CountryCodes enum' do
      let( :enum_value ){ Fortnox::API::Types::CountryCodes.values.sample }
      let( :input ){ enum_value.downcase }
      subject{ described_class[ input ] }
      it{ is_expected.to eq enum_value }
    end

    context 'created with a string that starts like a random member from the CountryCodes enum' do
      let( :enum_value ){ Fortnox::API::Types::CountryCodes.values.sample }
      let( :input ){ enum_value.downcase + 'more string' }
      subject{ described_class[ input ] }
      it{ is_expected.to eq enum_value }
    end

    context 'created with invalid input' do
      let( :input ){ 'r4nd0m' }
      subject { -> { described_class[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end
end
