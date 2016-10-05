shared_context 'models context' do
  shared_examples 'having value objects' do |value_object_class|
    context "when having a(n) #{value_object_class}" do
      it "returns the correct object" do
        value_object = value_object_class.new
        invoice = described_class.new( customer_number: '123', attribute => value_object )
        expect(invoice.send(attribute)).to eq(value_object)
      end
    end
  end
end
