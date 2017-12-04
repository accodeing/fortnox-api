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
    subject(:config_value){ Fortnox::API.config[config_key]}
    before { Fortnox::API::TestBase.new }

    describe 'base_url' do
      let( :config_key ){ :base_url }
      it{ is_expected.to eql 'https://api.fortnox.se/3/' }
    end

    describe 'client_secret' do
      let( :config_key ){ :client_secret }
      it{ is_expected.to be_nil }
    end

    describe 'token_store' do
      let( :config_key ){ :token_store }
      it{ is_expected.to eql Hash.new }
    end

    describe 'debugging' do
      let( :config_key ){ :debugging }
      it{ is_expected.to eql false }
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
end
