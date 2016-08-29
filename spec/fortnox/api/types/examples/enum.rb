shared_examples_for 'enum' do |name, values, auto_crop: false|
  describe name do
    let( :klass ){ Fortnox::API::Types.const_get(name) }

    context 'created with nil' do
      subject{ klass[ nil ] }
      it{ is_expected.to be_nil }
    end

    context 'created with' do
      let( :enum_value ){ Fortnox::API::Types.const_get(values).values.sample }

      context "a random member from the #{name} enum" do
        subject{ klass[ enum_value ] }
        it{ is_expected.to eq enum_value }
      end

      context "a symoblised, random member from the #{name} enum" do
        let( :input ){ enum_value.to_sym }
        subject{ klass[ input ] }
        it{ is_expected.to eq enum_value }
      end

      context "a lower case, random member from the #{name} enum" do
        let( :input ){ enum_value.downcase }
        subject{ klass[ input ] }
        it{ is_expected.to eq enum_value }
      end

      context "a string that starts like a random member from the #{name} enum" do
        let( :input ){ enum_value.downcase + 'more string' }

        if auto_crop
          subject{ klass[ input ] }
          it{ is_expected.to eq enum_value }
        else
          subject{ -> { klass[ input ] } }
          it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
        end
      end
    end

    context 'created with invalid input' do
      let( :input ){ 'r4nd0m' }
      subject { -> { klass[ input ] } }
      it { is_expected.to raise_error(Dry::Types::ConstraintError) }
    end
  end
end
