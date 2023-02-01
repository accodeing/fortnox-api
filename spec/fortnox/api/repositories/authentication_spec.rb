# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/repositories/authentication'

describe Fortnox::API::Repository::Authentication, integration: true do
  include Helpers::Configuration

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  let(:vcr_dir) { 'authentication' }

  let(:valid_response) do
    VCR.use_cassette("#{vcr_dir}/valid_request") do
      repository.renew_tokens(
        refresh_token: ENV.fetch('FORTNOX_API_REFRESH_TOKEN'),
        client_id: ENV.fetch('FORTNOX_API_CLIENT_ID'),
        client_secret: ENV.fetch('FORTNOX_API_CLIENT_SECRET')
      )
    end
  end

  describe '#renew_tokens' do
    context 'with invalid authorization' do
      it 'raises an error' do
        expect do
          VCR.use_cassette("#{vcr_dir}/invalid_authorization") do
            repository.renew_tokens(
              refresh_token: ENV.fetch('FORTNOX_API_REFRESH_TOKEN'),
              client_id: 'nonsense_id',
              client_secret: 'nonsense_secret'
            )
          end
        end.to raise_error(Fortnox::API::RemoteServerError, /Unauthorized request(.)*Error:(.)*invalid_client/)
      end
    end

    context 'with invalid refresh token' do
      it 'raises an error' do
        expect do
          VCR.use_cassette("#{vcr_dir}/invalid_refresh_token") do
            repository.renew_tokens(
              refresh_token: 'invalid_refresh_token',
              client_id: ENV.fetch('FORTNOX_API_CLIENT_ID'),
              client_secret: ENV.fetch('FORTNOX_API_CLIENT_SECRET')
            )
          end
        end.to raise_error(Fortnox::API::RemoteServerError, /Bad request(.)*Error:(.)*Invalid refresh token/)
      end
    end

    describe 'returned hash' do
      subject { valid_response }

      it { is_expected.to include(:access_token, :refresh_token, :expires_in, :token_type, :scope) }
    end

    describe 'access_token' do
      subject { valid_response[:access_token] }

      it { is_expected.to be_a(String) }
      it { is_expected.not_to be_empty }
    end

    describe 'refresh_token' do
      subject { valid_response[:refresh_token] }

      it { is_expected.to be_a(String) }
      it { is_expected.not_to be_empty }
    end

    describe 'expires_in' do
      subject { valid_response[:expires_in] }

      it { is_expected.to be_a(Integer) }
    end

    describe 'token_type' do
      subject { valid_response[:token_type] }

      it { is_expected.to be_a(String) }
      it { is_expected.not_to be_empty }
    end

    describe 'scope' do
      subject { valid_response[:scope] }

      it { is_expected.to be_a(String) }
      it { is_expected.not_to be_empty }
    end
  end
end
