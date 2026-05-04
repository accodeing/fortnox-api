# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Fortnox::Auth::ThreadLocal do
  # Always run apply in a fresh thread so each example controls its own
  # Thread.current state and can't leak the access token spec_helper sets
  # on the main thread.
  # Always run apply in a fresh thread so each example controls its own
  # Thread.current state and can't leak the access token spec_helper sets
  # on the main thread.
  def in_thread(token: nil)
    Thread.new do
      Thread.current.report_on_exception = false
      Thread.current[Fortnox::Auth::ThreadLocal::THREAD_LOCAL_KEY] = token
      yield
    end.value
  end

  def auth_header_for(token:)
    request = Struct.new(:headers).new({})
    in_thread(token:) { described_class.new.apply(request) }
    request.headers['Authorization']
  end

  describe '#apply' do
    it 'sets the Authorization header to a Bearer token from the current thread' do
      expect(auth_header_for(token: 'my-token')).to eq('Bearer my-token')
    end

    it 'reads tokens independently per thread', :aggregate_failures do
      expect(auth_header_for(token: 'token_A')).to eq('Bearer token_A')
      expect(auth_header_for(token: 'token_B')).to eq('Bearer token_B')
    end

    it 'raises MissingAccessToken with a helpful message when no token is set' do
      expect { auth_header_for(token: nil) }
        .to raise_error(Fortnox::MissingAccessToken, /No access token set for the current thread/)
    end
  end

  describe '#on_rejected' do
    it 'raises RestEasy::RequestError so rest-easy stops retrying' do
      response = Struct.new(:status).new(401)
      expect { described_class.new.on_rejected(response) }.to raise_error(RestEasy::RequestError)
    end
  end
end
