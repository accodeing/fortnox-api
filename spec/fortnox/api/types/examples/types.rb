shared_examples_for 'equals input' do |input|
  subject{ described_class[ input ] }
  it{ is_expected.to eq input }
end

shared_examples_for 'raises ConstraintError' do |input|
  subject{ ->{ described_class[ input ] } }
  it{ is_expected.to raise_error(Dry::Types::ConstraintError) }
end
