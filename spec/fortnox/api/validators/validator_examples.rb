shared_examples_for 'validators' do

  it{ is_expected.to respond_to( :validate ) }
  it{ is_expected.to respond_to( :violations ) }
  it{ is_expected.to respond_to( :instance ) }

  context 'when validator present' do
    specify '#violations returns an empty Set when no violations present' do
      expect(subject.violations).to eq(Set.new)
    end

    specify '#validate returns true when model valid' do
      expect(subject.validate( valid_model )).to be true
    end

    specify '#instance returns self' do
      expect(subject.instance).to be subject
    end
  end
end
