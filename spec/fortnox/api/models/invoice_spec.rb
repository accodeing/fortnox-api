require 'spec_helper'
require 'fortnox/api/models/invoice'

describe Fortnox::API::Model::Invoice do
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
    context 'when having an EmailInformation' do
      it 'returns the correct EmailInformation' do
        email_information = Fortnox::API::Model::EmailInformation.new
        invoice = described_class.new( email_information: email_information )
        expect(invoice.email_information).to eq(email_information)
      end
    end
  end

  describe 'association with Fortnox::API::Model::EDIInformation' do
    context 'when having an EDIInformation' do
      it 'returns the correct EDIInformation' do
        edi_information = Fortnox::API::Model::EDIInformation.new
        invoice = described_class.new( edi_information: edi_information )
        expect(invoice.edi_information).to eq(edi_information)
      end
    end
  end
end
