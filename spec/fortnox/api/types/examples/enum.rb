require 'fortnox/api/types/examples/types'

shared_examples_for 'enum' do |name, values, auto_crop: false|
  describe name do
    let( :klass ){ Fortnox::API::Types.const_get(name) }

    context 'created with nil' do
      subject{ klass[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with' do
      subject{ klass[ input ] }

      let( :enum_value ){ Fortnox::API::Types.const_get(values).values.sample }

      context 'a random member from then enum' do
        let(:input){ enum_value }
        it{ is_expected.to eq enum_value }
      end

      context 'a symoblised, random member from the enum' do
        let( :input ){ enum_value.to_sym }
        it{ is_expected.to eq enum_value }
      end

      context 'a lower case, random member from the enum' do
        let( :input ){ enum_value.downcase }
        it{ is_expected.to eq enum_value }
      end

      context 'a string that starts like a random member from the enum' do
        let( :input ){ enum_value.downcase + 'more string' }

        if auto_crop
          it{ is_expected.to eq enum_value }
        else
          subject{ ->{ klass[ input ] } }
          it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
        end
      end
    end

    context 'created with invalid input' do
      include_examples 'raises ConstraintError', 'r4nd0m'
    end
  end
end
