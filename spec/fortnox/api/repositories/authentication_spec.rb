# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'fortnox/api/repositories/authentication'

describe Fortnox::API::Repository::Authentication, integration: true, order: :defined do
  include Helpers::Configuration

  subject(:repository) { described_class.new }

  before { set_api_test_configuration }

  let(:vcr_dir) { 'authentication' }

  describe '#renew_access_token' do
    context 'with nil' do
      it 'raises an error' do
        expect { repository.renew_access_token(nil) }.to raise_error(ArgumentError, 'Refresh token is empty!')
      end
    end

    context 'with empty string' do
      it 'raises an error' do
        expect { repository.renew_access_token('') }.to raise_error(ArgumentError, 'Refresh token is empty!')
      end
    end

    describe 'missing configuration' do
      let(:calling_renew_access_token) { repository.renew_access_token('access_token') }

      context 'without client_id' do
        before { Fortnox::API.configure { |c| c.client_secret = 'a secret' } }

        it 'raises an error' do
          expect { calling_renew_access_token }.to raise_error(Fortnox::API::MissingConfiguration, /client id/)
        end
      end

      context 'without client_secret' do
        before { Fortnox::API.configure { |c| c.client_id = 'an id' } }

        it 'raises an error' do
          expect { calling_renew_access_token }.to raise_error(Fortnox::API::MissingConfiguration, /client secret/)
        end
      end
    end

    context 'with invalid client' do
      before do
        Fortnox::API.configure do |config|
          config.client_secret = 'nonsense'
          config.client_id = 'nonsense'
        end
      end

      it 'raises an error' do
        expect do
          VCR.use_cassette("#{vcr_dir}/invalid_client") do
            puts repository.renew_access_token('invalid_refresh_token')
          end
        end.to raise_error(Fortnox::API::RemoteServerError, /Unauthorized request(.)*Error:(.)*invalid_client/)
      end
    end

    context 'with valid config' do
      before do
        # VCR: Valid config required
        Fortnox::API.configure do |config|
          config.client_secret = ENV.fetch('FORTNOX_API_CLIENT_SECRET')
          config.client_id = ENV.fetch('FORTNOX_API_CLIENT_ID')
        end
      end

      context 'with invalid refresh token' do
        it 'raises an error' do
          expect do
            VCR.use_cassette("#{vcr_dir}/invalid_refresh_token") do
              puts repository.renew_access_token('invalid_refresh_token')
            end
          end.to raise_error(Fortnox::API::RemoteServerError, /Bad request(.)*Error:(.)*Invalid refresh token/)
        end
      end

      context 'with valid refresh token' do
        let(:response) do
          VCR.use_cassette("#{vcr_dir}/valid_refresh_token") do
            repository.renew_access_token(ENV.fetch('FORTNOX_API_REFRESH_TOKEN'))
          end
        end

        describe 'returned hash' do
          subject { response }

          it { is_expected.to include(:access_token) }
          it { is_expected.to include(:refresh_token) }
          it { is_expected.to include(:expires_in) }
          it { is_expected.to include(:token_type) }
          it { is_expected.to include(:scope) }
        end

        describe 'access_token' do
          subject { response[:access_token] }

          it { is_expected.to be_a(String) }
          it { is_expected.not_to be_empty }
        end

        describe 'refresh_token' do
          subject { response[:refresh_token] }

          it { is_expected.to be_a(String) }
          it { is_expected.not_to be_empty }
        end

        describe 'expires_in' do
          subject { response[:expires_in] }

          it { is_expected.to be_a(Integer) }
        end

        describe 'refresh_token' do
          subject { response[:token_type] }

          it { is_expected.to be_a(String) }
          it { is_expected.not_to be_empty }
        end

        describe 'refresh_token' do
          subject { response[:scope] }

          it { is_expected.to be_a(String) }
          it { is_expected.not_to be_empty }
        end
      end
    end
  end
end
