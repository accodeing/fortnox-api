# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Mappers::EmailInformation do
  let(:api_data) do
    { 'EmailAddressTo' => 'to@example.com', 'EmailAddressCC' => 'cc@example.com',
      'EmailAddressBCC' => 'bcc@example.com' }
  end

  let(:struct) do
    Fortnox::Structs::EmailInformation.new(email_address_to: 'to@example.com', email_address_cc: 'cc@example.com',
                                           email_address_bcc: 'bcc@example.com')
  end

  describe '.parse' do
    it 'maps the CC and BCC API keys to their model attributes', :aggregate_failures do
      result = described_class.parse(api_data)
      expect(result.email_address_to).to eq('to@example.com')
      expect(result.email_address_cc).to eq('cc@example.com')
      expect(result.email_address_bcc).to eq('bcc@example.com')
    end
  end

  describe '.serialise' do
    it 'maps the CC and BCC model attributes back to their API keys' do
      expect(described_class.serialise(struct)).to eq(api_data)
    end
  end
end
