require 'fortnox/api/models/context'

shared_examples_for 'DocumentBase' do |row_class, row_attribute|

  context "when having a(n) #{row_class}" do
    it 'returns the correct object' do
      row = row_class.new
      document_base = described_class.new( row_attribute => [row] )
      expect(document_base.send(row_attribute)).to eq([row])
    end
  end

  include_context 'models context'

  include_examples 'having value objects', Fortnox::API::Model::EmailInformation do
    let( :attribute ){ :email_information }
  end
end
