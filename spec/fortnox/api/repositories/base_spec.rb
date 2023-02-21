# frozen_string_literal: true

require 'spec_helper'
require 'fortnox/api'
require 'jwt'
require 'dry/container/stub'

describe Fortnox::API::Repository::Base, integration: true do
  include Helpers::Configuration

  before do
    stub_const('TestModel', Class.new)
    stub_const('TestRepository', Class.new(described_class))
    stub_const('TestRepository::MODEL', TestModel)

    Fortnox::API::Registry.enable_stubs!

    add_to_registry(:testmodel, TestModel)
  end

  let(:repository) { TestRepository.new }

  describe '#initialize' do
    context 'without providing an access token' do
      before { Fortnox::API.access_token = nil }

      it 'raises an error' do
        expect { TestRepository.new }.to raise_error(Fortnox::API::MissingAccessToken)
      end
    end

    context 'with expired access token' do
      before { Fortnox::API.access_token = ENV.fetch('EXPIRED_ACCESS_TOKEN') }

      it 'raises an error' do
        expect do
          VCR.use_cassette('authentication/expired_token') { repository.get('/customers', body: '') }
        end.to raise_error(Fortnox::API::RemoteServerError, /Unauthorized request(.)*"message":"unauthorized"/)
      end
    end
  end

  context 'when making a request including the proper headers' do
    subject { repository.get('/test', body: '') }

    before do
      set_api_test_configuration

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
      set_api_test_configuration

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
      end.to raise_error(Fortnox::API::RemoteServerError, /some-error-message/)
    end

    context 'with debugging enabled' do
      before { Fortnox::API.config.debugging = true }
      after { Fortnox::API.config.debugging = false }

      it do
        expect do
          repository.post('/test', body: '')
        end.to raise_error(/<HTTParty::Request:0x/)
      end
    end
  end

  context 'when receiving HTML from remote server' do
    before do
      set_api_test_configuration

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

  describe 'update existing' do
    context 'with no change' do
      before do
        set_api_test_configuration

        stub_const(
          'Product',
          Class.new(Fortnox::API::Model::Base) do
            attribute :name, 'strict.string'
            attribute :description, 'string' # nullable
          end
        )
        stub_const('Product::STUB', { name: '' }.freeze)
        stub_const('Product::UNIQUE_ID', :name)

        stub_const('ProductMapper', Class.new(Fortnox::API::Mapper::Base))
        stub_const('ProductMapper::JSON_ENTITY_WRAPPER', 'Product')
        stub_const('ProductMapper::JSON_COLLECTION_WRAPPER', 'Products')
        stub_const('ProductMapper::KEY_MAP', {})

        stub_const('TestRepository::MODEL', Product)
        stub_const('TestRepository::MAPPER', ProductMapper)
        stub_const('TestRepository::URI', '/test/')

        Fortnox::API::Registry.enable_stubs!
        add_to_registry(:product, ProductMapper)

        stub_request(
          :post,
          'https://api.fortnox.se/3/test/'
        ).to_return(
          status: 200,
          body: '{"Product" : {"Name": "test", "Desription": null}}',
          headers: { 'Content-Type' => 'application/json' }
        ).times(1) # Only stub the first save request
      end

      let(:updated_entity) do
        repository.save(Product.new(name: 'test')).update({ description: nil })
      end

      it 'does not call Fortnox' do
        expect { repository.save(updated_entity) }.not_to raise_error
      end
    end
  end
end
