require 'fortnox/api/models/examples/model'

shared_examples_for 'DocumentBase Model' do |row_class, row_attribute, valid_hash, valid_row_hash: {}|
  it_behaves_like 'a model', valid_hash, :document_number, 1

  context "when having a(n) #{ row_class }" do
    it 'returns the correct object' do
      row = row_class.new(valid_row_hash)
      document_base = described_class.new( customer_number: '123', row_attribute => [row] )
      expect(document_base.send(row_attribute)).to eq([row])
    end
  end
end
