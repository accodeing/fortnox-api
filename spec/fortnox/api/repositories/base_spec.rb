# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'jwt'
require 'timecop'

describe Fortnox::API::Repository::Base do
  before do
    stub_const('Model::RepositoryBaseTest', Class.new)
    stub_const('Repository::Test', Class.new(described_class))
    stub_const('Repository::Test::MODEL', Model::RepositoryBaseTest)

    Fortnox::API::Registry.register(:repositorybasetest, Model::RepositoryBaseTest)
  end

  after do
    # HACK: Currently, there is no way to remove keys from the Dry::Container#register.
    # We could move the register call to a before(:all) hook, but that registered key
    # would then leak into other tests. Instead, we can simply delete it with this little hack :)
    Fortnox::API::Registry._container.delete('repositorybasetest')
  end

  let(:token_store) do
    Class.new do
      def access_token
        # NOTE: Use Timecop with time_when_mocked_jwt_is_valid to use the mocked JWT
        JWT.encode({ exp: 1_654_159_274 }, nil, 'none')
      end

      def refresh_token
        'test-refresh-token'
      end

      def access_token=(token); end

      def refresh_token=(token); end
    end
  end
  let(:time_when_mocked_jwt_is_valid) { Time.at(1_654_150_000) }
  let(:time_when_mocked_jwt_has_expired) { Time.at(1_654_159_275) }

  let(:client_id) { 'test-client-id' }
  let(:client_secret) { 'test-client-secret' }
  let(:repository) { Repository::Test.new }

  shared_examples_for 'missing configuration' do
    it 'raises an error' do
      expect do
        Repository::Test.new.get('/test')
      end.to raise_error(Fortnox::API::MissingConfiguration, error_message)
    end
  end

  shared_examples_for 'raises exception' do
    it 'raises an error' do
      expect do
        Repository::Test.new.get('/test')
      end.to raise_error(Fortnox::API::Exception, error_message)
    end
  end

  describe 'configuration' do
    context 'without any configuration' do
      include_examples 'missing configuration' do
        let(:error_message) { /There is no token store named "default"/ }
      end
    end

    context 'without client id' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_secret = client_secret
            config.token_stores = { default: token_store.new }
          end
        end

        let(:error_message) { /have to provide your client id/ }
      end
    end

    context 'without token stores' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.client_secret = client_secret
          end
        end

        let(:error_message) { /There is no token store named "default"/ }
      end
    end

    context 'without client_secret' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.token_stores = { default: token_store.new }
          end
        end

        let(:error_message) { /have to provide your client secret/ }
      end
    end

    context 'with a store without #access_token implementation' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.client_secret = client_secret
            config.token_stores = { default: Class.new do
              def refresh_token; end

              def access_token=; end

              def refresh_token=; end
            end.new }
          end
        end

        let(:error_message) { /does not implement required #access_token/ }
      end
    end

    context 'with a store without #refresh_token implementation' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.client_secret = client_secret
            config.token_stores = { default: Class.new do
              def access_token; end

              def access_token=; end

              def refresh_token=; end
            end.new }
          end
        end

        let(:error_message) { /does not implement required #refresh_token/ }
      end
    end

    context 'with a store without #access_token= implementation' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.client_secret = client_secret
            config.token_stores = { default: Class.new do
              def access_token; end

              def refresh_token; end

              def refresh_token=; end
            end.new }
          end
        end

        let(:error_message) { /does not implement required #access_token=/ }
      end
    end

    context 'with a store without #refresh_token= implementation' do
      include_examples 'missing configuration' do
        before do
          Fortnox::API.configure do |config|
            config.client_id = client_id
            config.client_secret = client_secret
            config.token_stores = { default: Class.new do
              def access_token; end

              def access_token=; end

              def refresh_token; end
            end.new }
          end
        end

        let(:error_message) { /does not implement required #refresh_token=/ }
      end
    end

    context 'with multiple token stores' do
      before do
        Fortnox::API.configure do |config|
          config.client_id = client_id
          config.client_secret = client_secret
        end

        stub_request(
          :get,
          'https://api.fortnox.se/3/test'
        ).to_return(
          status: 200
        )
      end

      context 'with default token store' do
        before do
          Fortnox::API.configure do |config|
            config.token_stores = { default: token_store.new, another: token_store.new }
          end
          Timecop.freeze(time_when_mocked_jwt_is_valid)
        end

        after { Timecop.return }

        it 'does not raise an error' do
          expect { Repository::Test.new.get('/test') }.not_to raise_error
        end
      end

      context 'without default token store' do
        before do
          Fortnox::API.configure do |config|
            config.token_stores = { another: token_store.new }
          end

          stub_request(
            :get,
            'https://api.fortnox.se/3/test'
          ).to_return(
            status: 200
          )

          Timecop.freeze(time_when_mocked_jwt_is_valid)
        end

        after { Timecop.return }

        it 'raises an error when trying to use default token store' do
          expect do
            Repository::Test.new.get('/test')
          end.to raise_error(Fortnox::API::MissingConfiguration,
                             /There is no token store named "default"/)
        end

        it 'does not raise an error when using an explicit token store' do
          expect do
            Repository::Test.new(token_store: :another).get('/test')
          end.not_to raise_error
        end
      end

      context 'with invalid token store name' do
        before do
          Fortnox::API.configure do |config|
            config.token_stores = { default: token_store.new, another: token_store.new }
          end
        end

        it 'does not raise an error' do
          expect do
            Repository::Test.new(token_store: :invalid).get('/test')
          end.to raise_error(Fortnox::API::MissingConfiguration,
                             /There is no token store named "invalid"/)
        end
      end
    end
  end

  describe '#access_tokens' do
    before do
      Fortnox::API.configure do |config|
        config.client_secret = client_secret
        config.client_id = client_id
      end
    end

    context 'with nil access and refresh tokens' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = {
            default: Class.new do
              def access_token; end

              def refresh_token; end

              def access_token=; end

              def refresh_token=; end
            end.new
          }
        end
      end

      it 'raises an error' do
        expect do
          repository.access_token
        end.to raise_error(Fortnox::API::MissingConfiguration, /Refresh token for store "default" is empty/)
      end
    end

    context 'with empty access and refresh tokens' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = {
              default: Class.new do
              def access_token
                ''
              end

              def refresh_token
                ''
              end

              def access_token=; end

              def refresh_token=; end
            end.new
          }
        end
      end

      it 'raises an error' do
        expect do
          repository.access_token
        end.to raise_error(Fortnox::API::MissingConfiguration, /Refresh token for store "default" is empty/)
      end
    end

    context 'with nonsense access token' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = {
            default: Class.new do
              def access_token
                'nonsense'
              end

              def refresh_token; end

              def access_token=; end

              def refresh_token=; end
            end.new
          }
        end
      end

      it 'raises an error' do
        expect do
          repository.access_token
        end.to raise_error(Fortnox::API::Exception, /Could not decode access token for token store "default"/)
      end
    end

    context 'with nonsense refresh token' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = {
            default: Class.new do
              def access_token; end

              def refresh_token
                'nonsense'
              end

              def access_token=; end

              def refresh_token=; end
            end.new
          }
        end

        stub_request(:post, 'https://apps.fortnox.se/oauth-v1/token')
          .to_return(
            body: '{"error":"invalid_grant","error_description":"Invalid refresh token"}',
            status: [400, 'Bad Request'],
            headers: { content_type: 'text/html' } # NOTE: Yes, Fortnox API actually returns html here...
          )
      end

      # rubocop:disable RSpec/ExampleLength
      it 'raises an error' do
        expect { repository.access_token }.to raise_error(
          Fortnox::API::Exception,
          'Unable to renew access token. ' \
          'Response code: 400. ' \
          'Response message: Bad Request. ' \
          'Response body: {"error":"invalid_grant","error_description":"Invalid refresh token"}'
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'with no access token available' do
      context 'with expired refresh token' do
        before do
          Fortnox::API.configure do |config|
            config.token_stores = {
              default: Class.new do
                def access_token; end

                def refresh_token
                  '82f569dcbce8a0b79824e398c16ba6be6c9d8f54'
                end

                def access_token=; end

                def refresh_token=; end
              end.new
            }

            stub_request(:post, 'https://apps.fortnox.se/oauth-v1/token')
              .to_return(
                body: '{"error":"invalid_grant","error_description":"Invalid refresh token"}',
                status: [400, 'Bad Request'],
                headers: { content_type: 'text/html' } # NOTE: Yes, Fortnox API actually returns html here...
              )
          end
        end

        # rubocop:disable RSpec/ExampleLength
        it 'raises an error' do
          expect { repository.access_token }.to raise_error(
            Fortnox::API::Exception,
            'Unable to renew access token. ' \
            'Response code: 400. ' \
            'Response message: Bad Request. ' \
            'Response body: {"error":"invalid_grant","error_description":"Invalid refresh token"}'
          )
        end
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid access token' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = {
            default: Class.new do
              def access_token
                'invalid-token'
              end

              def refresh_token
                'not-used'
              end

              def access_token=(token); end

              def refresh_token=(token); end
            end.new
          }
        end
      end

      it 'raises an error' do
        expect do
          repository.access_token
        end.to raise_error(Fortnox::API::Exception,
                           'Could not decode access token for token store "default"')
      end
    end

    context 'with expired access token and valid refersh token' do
      before do
        Fortnox::API.configure do |config|
          config.token_stores = { default: token_store_spy }
        end

        stub_request(:post, 'https://apps.fortnox.se/oauth-v1/token')
          .to_return(
            body: '{"access_token":"new-access-token","refresh_token":"new-refresh-token"}',
            status: 200,
            headers: { content_type: 'application/json' }
          )

        repository.access_token

        Timecop.freeze(time_when_mocked_jwt_has_expired)
      end

      after { Timecop.return }

      let(:token_store_spy) do
        Class.new do
          attr_reader :received_access_token
          attr_reader :received_refresh_token

          def initialize; end

          def access_token
            JWT.encode({ exp: 1_654_159_274 }, nil, 'none')
          end

          def refresh_token
            'test-refresh-token'
          end

          def access_token=(token)
            @received_access_token = token
          end

          def refresh_token=(token)
            @received_refresh_token = token
          end
        end.new
      end

      it 'renews access token and stores it in the token store' do
        expect(token_store_spy.received_access_token).to eq 'new-access-token'
      end

      it 'renews refresh token and stores it in the token store' do
        expect(token_store_spy.received_refresh_token).to eq 'new-refresh-token'
      end
    end
  end

  context 'when making a request including the proper headers' do
    subject { repository.get('/test', body: '') }

    before do
      Fortnox::API.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.token_stores = { default: token_store.new }
      end

      stub_request(
        :get,
        'https://api.fortnox.se/3/test'
      ).to_return(
        status: 200
      )

      Timecop.freeze(time_when_mocked_jwt_is_valid)
    end

    after { Timecop.return }

    it { is_expected.to be_nil }
  end

  context 'when receiving an error from remote server' do
    before do
      Fortnox::API.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.token_stores = { default: token_store.new }
      end

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

      Timecop.freeze(time_when_mocked_jwt_is_valid)
    end

    after { Timecop.return }

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
        end.to raise_error(/\<HTTParty\:\:Request\:0x/)
      end
    end
  end

  context 'when receiving HTML from remote server' do
    before do
      Fortnox::API.configure do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.token_stores = { default: token_store.new }
      end

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

      Timecop.freeze(time_when_mocked_jwt_is_valid)
    end

    after { Timecop.return }

    it 'raises an error' do
      expect do
        repository.get('nonsense')
      end.to raise_error(Fortnox::API::RemoteServerError,
                         %r{Fortnox API's response has content type "text/html"})
    end
  end
end
