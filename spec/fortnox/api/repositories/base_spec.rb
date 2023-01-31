# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'jwt'
require 'dry/container/stub'

describe Fortnox::API::Repository::Base do
  before do
    stub_const('Model::RepositoryBaseTest', Class.new)
    stub_const('Repository::Test', Class.new(described_class))
    stub_const('Repository::Test::MODEL', Model::RepositoryBaseTest)

    Fortnox::API::Registry.enable_stubs!

    # Only register the key once...
    unless Fortnox::API::Registry.key? :repositorybasetest
      Fortnox::API::Registry.register(:repositorybasetest, Model::RepositoryBaseTest)
    end

    # ... but stub the value each test run
    Fortnox::API::Registry.stub(:repositorybasetest, Model::RepositoryBaseTest)
  end

  let(:client_id) { 'test-client-id' }
  let(:client_secret) { 'test-client-secret' }
  let(:repository) { Repository::Test.new }

  def set_required_config
    Fortnox::API.configure do |config|
      config.client_secret = nil
      config.client_id = nil
    end

    Fortnox::API.access_token = 'an_access_token'
  end

  describe '#initialize' do
    context 'without providing an access token' do
      before { Fortnox::API.access_token = nil }

      it 'raises an error' do
        expect { Repository::Test.new }.to raise_error(Fortnox::API::MissingAccessToken)
      end
    end
  end

  describe '#access_token' do
    context 'with expired access token' do
      before { Fortnox::API.access_token = ENV.fetch('EXPIRED_ACCESS_TOKEN') }

      it 'raises an error' do
        expect do
          VCR.use_cassette("authentication/expired_token") { expect(repository.get('/customers', body: '')) }
        end.to raise_error(Fortnox::API::RemoteServerError, /Unauthorized request(.)*"message":"unauthorized"/)
      end
    end
  end

  context 'when making a request including the proper headers' do
    subject { repository.get('/test', body: '') }

    before do
      set_required_config

      stub_request(
        :get,
        'https://api.fortnox.se/3/test'
      ).to_return(
        status: 200
      )
    end

    it { is_expected.to be_nil }
  end

  context 'when receiving an error from remote server' do
    before do
      set_required_config

      stub_request(
        :post,
        'https://api.fortnox.se/3/test'
      ).to_return(
        status: 500,
        body: {
          'ErrorInformation' => {
            'error' => 1,
            'message' => 'some-error-message'
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'raises an error' do
      expect do
        repository.post('/test', body: '')
      end.to raise_error(Fortnox::API::RemoteServerError, 'some-error-message')
    end

    context 'with debugging enabled' do
      around do |example|
        Fortnox::API.config.debugging = true
        example.run
        Fortnox::API.config.debugging = false
      end

      it do
        expect do
          repository.post('/test', body: '')
        end.to raise_error(/<HTTParty::Request:0x/)
      end
    end
  end

  context 'when receiving HTML from remote server' do
    before do
      set_required_config

      stub_request(
        :get,
        'https://api.fortnox.se/3nonsense'
      ).to_return(
        status: 404,
        body: "<html>\r\n" \
              "<head><title>404 Not Found</title></head>\r\n" \
              "<body>\r\n<center><h1>404 Not Found</h1></center>\r\n" \
              "<hr><center>nginx</center>\r\n</body>\r\n</html>\r\n",
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    it 'raises an error' do
      expect do
        repository.get('nonsense')
      end.to raise_error(Fortnox::API::RemoteServerError,
                         %r{Fortnox API's response has content type "text/html"})
    end
  end
end
