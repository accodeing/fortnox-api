require 'spec_helper'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Model::Invoice do
  shared_examples 'having value objects' do |value_object_class|
    context "when having an #{value_object_class}" do
      it "returns the correct object" do
        value_object = value_object_class.new
        invoice = described_class.new( attribute => value_object )
        expect(invoice.send(attribute)).to eq(value_object)
      end
    end
  end

  describe 'association with Fortnox::API::Model::Row' do
    context 'when having an Invoice Row' do
      it 'returns the correct Row' do
        row = Fortnox::API::Model::Row.new
        invoice = described_class.new( invoice_rows: [row] )
        expect(invoice.invoice_rows).to eq([row])
      end
    end
  end

  describe 'association with Fortnox::API::Model::EmailInformation' do
    include_examples 'having value objects', Fortnox::API::Model::EmailInformation do
      let( :attribute ){ :email_information }
    end
  end

  describe 'association with Fortnox::API::Model::EDIInformation' do
    include_examples 'having value objects', Fortnox::API::Model::EDIInformation do
      let( :attribute ){ :edi_information }
    end
  end
end
