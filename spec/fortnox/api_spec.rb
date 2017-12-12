require 'spec_helper'
require 'fortnox/api'

describe Fortnox::API do
  before do
    module Fortnox
      module API
        class TestBase
        end
      end
    end
  end

  describe 'configuration defaults' do
    subject(:config_value){ described_class.config[config_key] }
    before{ Fortnox::API::TestBase.new }

    describe 'base_url' do
      let( :config_key ){ :base_url }
      it{ is_expected.to eql 'https://api.fortnox.se/3/' }
    end

    describe 'client_secret' do
      let( :config_key ){ :client_secret }
      it{ is_expected.to be_nil }
    end

    describe 'access_token' do
      let( :config_key ){ :access_token }
      it{ is_expected.to be_nil }
    end

    describe 'access_tokens' do
      let( :config_key ){ :access_tokens }
      it{ is_expected.to be_nil }
    end

    describe 'token_store' do
      let( :config_key ){ :token_store }
      it{ is_expected.to eql( {} ) }
    end

    describe 'debugging' do
      let( :config_key ){ :debugging }
      it{ is_expected.to be false }
    end

    describe 'logger' do
      let( :config_key ){ :logger }
      it{ is_expected.to be_a Logger }

      describe 'level' do
        subject{ config_value.level }
        it{ is_expected.to be Logger::WARN }
      end
    end
  end

  describe 'access_token' do
    context 'when set to a String' do
      subject{ described_class.config.access_token }
      before{ described_class.configure{ |config| config.access_token = value } }
      let( :value ){ '12345' }
      it{ is_expected.to eql value }
    end

    shared_examples_for 'invalid argument' do
      subject{ ->{ described_class.configure{ |config| config.access_token = value } } }
      it{ is_expected.to raise_error(ArgumentError, /expected a String/) }
    end

    context 'when set to a Hash' do
      include_examples 'invalid argument' do
        let( :value ){ { a: '123' } }
      end
    end

    context 'when set to an Array' do
      include_examples 'invalid argument' do
        let( :value ){ ['123', '456'] }
      end
    end
  end

  describe 'access_tokens' do
    context 'when set to a String' do
      subject{ ->{ described_class.configure{ |config| config.access_tokens = '12345' } } }
      it{ is_expected.to raise_error(ArgumentError, /expected a Hash or an Array/) }
    end

    shared_examples_for 'valid argument' do
      subject{ described_class.configure{ |config| config.access_tokens = value } }
      it{ is_expected.to eql( value ) }
    end

    context 'when set to a Hash' do
      include_examples 'valid argument' do
        let( :value ){ { a: '123', b: '456' } }
      end
    end

    context 'when set to an Array' do
      include_examples 'valid argument' do
        let( :value ){ ['123', '456'] }
      end
    end
  end

  describe 'token_store' do
    subject{ described_class.config[:token_store] }

    context 'when access_token set' do
      before{ described_class.configure{ |config| config.access_token = access_token } }
      let( :access_token ){ '12345' }
      it{ is_expected.to eql(default: access_token) }
    end

    context 'when access_tokens is' do
      before{ described_class.configure{ |config| config.access_tokens = access_tokens } }

      context 'a Hash' do
        let( :access_tokens ){ { a: '123', b: '456' } }
        it{ is_expected.to eql( access_tokens ) }
      end

      context 'an Array' do
        let( :access_tokens ){ ['123', '456'] }
        it{ is_expected.to eql( default: access_tokens ) }
      end
    end
  end

  describe 'readers for' do
    describe 'debugging' do
      subject{ described_class.debugging }

      it 'is available' do
        is_expected.to be false
      end
    end

    describe 'logger' do
      subject{ described_class.logger }

      it 'is available' do
        is_expected.to be_a Logger
      end
    end
  end
end
