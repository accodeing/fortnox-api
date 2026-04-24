# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox do
  let(:vcr_dir) { 'authentication' }

  describe '.request_access_token' do
    context 'with valid credentials' do
      let(:token) do
        VCR.use_cassette("#{vcr_dir}/valid_request") do
          described_class.request_access_token(
            client_id: ENV.fetch('FORTNOX_CLIENT_ID'),
            client_secret: ENV.fetch('FORTNOX_CLIENT_SECRET'),
            tenant_id: ENV.fetch('FORTNOX_TENANT_ID')
          )
        end
      end

      it 'returns an access token', :aggregate_failures do
        expect(token).to be_a(String)
        expect(token).not_to be_empty
      end
    end

    context 'with invalid credentials' do
      let(:request_with_invalid_credentials) do
        VCR.use_cassette("#{vcr_dir}/invalid_credentials") do
          described_class.request_access_token(
            client_id: 'invalid',
            client_secret: 'invalid',
            tenant_id: '0'
          )
        end
      end

      it 'raises an error' do
        expect { request_with_invalid_credentials }.to raise_error(Fortnox::RequestError)
      end
    end
  end
end
