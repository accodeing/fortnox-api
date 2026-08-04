# frozen_string_literal: true

require 'spec_helper'

class TestResource < Fortnox::Resource
  configure do
    path 'things'
    instance_wrapper 'Thing'
    collection_wrapper 'Things'
  end

  attr :name, Fortnox::Types::Coercible::String.optional, :key
  attr :comment, Fortnox::Types::Coercible::String.optional
  attr :count, Fortnox::Types::Coercible::Integer.optional
end

class StrictResource < Fortnox::Resource
  configure do
    path 'strict_things'
    instance_wrapper 'StrictThing'
    collection_wrapper 'StrictThings'
  end

  attr :name, Fortnox::Types::Strict::String, :required
  attr :short_code, Fortnox::Types::Sized::String[5]
end

RSpec.describe Fortnox::Resource do
  describe '#serialise' do
    context 'with a new record' do
      subject(:serialised) { instance.serialise }

      let(:instance) { TestResource.stub(name: 'test', comment: 'hello') }

      it 'wraps in instance wrapper' do
        expect(serialised).to have_key('Thing')
      end

      it 'includes set attributes' do
        expect(serialised['Thing']).to include('Name' => 'test', 'Comment' => 'hello')
      end

      it 'strips nil attributes' do
        expect(serialised['Thing']).not_to have_key('Count')
      end
    end

    context 'with a saved record with changes' do
      subject(:serialised) { updated.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end
      let(:updated) { saved.update(comment: 'changed') }

      it 'wraps in instance wrapper' do
        expect(serialised).to have_key('Thing')
      end

      it 'only includes changed attributes' do
        expect(serialised['Thing']).to eq('Comment' => 'changed')
      end
    end

    context 'with a saved record setting a value to nil' do
      subject(:serialised) { updated.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end
      let(:updated) { saved.update(comment: nil) }

      it 'preserves the nil value' do
        expect(serialised['Thing']).to eq('Comment' => nil)
      end
    end

    context 'with a saved record with no changes' do
      subject(:serialised) { saved.serialise }

      let(:saved) do
        TestResource.send(:parse, { 'Thing' => { 'Name' => 'test', 'Comment' => 'hello', 'Count' => 5 } })
      end

      it 'includes all attributes' do
        expect(serialised['Thing']).to include('Name' => 'test', 'Comment' => 'hello', 'Count' => 5)
      end
    end
  end

  describe 'error translation' do
    it 'raises Fortnox::ConstraintError preserving attribute_name and value' do
      expect { StrictResource.stub(name: 'ok', short_code: 'too long') }.to raise_error(
        an_instance_of(Fortnox::ConstraintError)
          .and(having_attributes(attribute_name: :short_code, value: 'too long'))
      )
    end

    it 'raises Fortnox::MissingAttributeError preserving attribute_name' do
      expect { StrictResource.send(:parse, 'StrictThing' => {}) }.to raise_error(
        an_instance_of(Fortnox::MissingAttributeError).and(having_attributes(attribute_name: :name))
      )
    end

    it 'raises Fortnox::ConstraintError from instance-level #update' do
      saved = StrictResource.send(:parse, 'StrictThing' => { 'Name' => 'x', 'ShortCode' => 'ok' })
      expect { saved.update(short_code: 'too long') }.to raise_error(
        an_instance_of(Fortnox::ConstraintError)
          .and(having_attributes(attribute_name: :short_code, value: 'too long'))
      )
    end

    it 'raises Fortnox::ConstraintError from .new' do
      expect { StrictResource.new(name: 'ok', short_code: 'too long') }.to raise_error(
        an_instance_of(Fortnox::ConstraintError)
          .and(having_attributes(attribute_name: :short_code, value: 'too long'))
      )
    end

    it 'raises Fortnox::MissingAttributeError from instance-level #serialise' do
      instance = StrictResource.stub(short_code: 'ok')
      expect { instance.serialise }.to raise_error(
        an_instance_of(Fortnox::MissingAttributeError).and(having_attributes(attribute_name: :name))
      )
    end

    it 'raises Fortnox::MissingAttributeError from save when a required attribute is missing' do
      instance = StrictResource.stub(short_code: 'ok')
      expect { StrictResource.save(instance) }.to raise_error(
        an_instance_of(Fortnox::MissingAttributeError).and(having_attributes(attribute_name: :name))
      )
    end

    it 'raises Fortnox::RequestError preserving the response' do
      response = instance_double(Faraday::Response, status: 503, body: nil)
      raising = -> { TestResource.send(:with_translated_errors) { raise RestEasy::RequestError, response } }
      expect(&raising).to raise_error(
        an_instance_of(Fortnox::RequestError).and(having_attributes(response: response))
      )
    end

    it "exposes the API's error message in the exception message (PascalCase body keys)" do
      find_missing_customer = lambda {
        VCR.use_cassette('customers/find_failure') { Fortnox::Customer.find('123456789') }
      }
      expect(&find_missing_customer).to raise_error(Fortnox::RequestError, /Kan inte hitta kunden/)
    end

    it "exposes the API's error message in the exception message (lowercase body keys)" do
      filter_invalid_orders = lambda {
        VCR.use_cassette('orders/filter_invalid') { Fortnox::Order.only('doesntexist') }
      }
      expect(&filter_invalid_orders).to raise_error(Fortnox::RequestError, /Ett ogiltigt filter har använts/)
    end

    it 'falls back to the raw body when no ErrorInformation is present' do
      html = '<html><body>503 Service Temporarily Unavailable</body></html>'
      response = instance_double(Faraday::Response, status: 503, body: html)
      expect(Fortnox::RequestError.new(response).message).to eq("Request failed: 503 - #{html}")
    end

    it 'truncates the raw-body fallback to bound the exception message' do
      response = instance_double(Faraday::Response, status: 503, body: 'x' * 600)
      expect(Fortnox::RequestError.new(response).message).to eq("Request failed: 503 - #{'x' * 500}…")
    end
  end

  describe 'partial flag' do
    it 'marks instances parsed from a collection response as partial' do
      collection = TestResource.send(:parse, 'Things' => [{ 'Name' => 'a' }, { 'Name' => 'b' }])
      expect(collection).to all(satisfy { |instance| instance.meta.partial? })
    end

    it 'marks an instance parsed from a single-resource response as not partial' do
      instance = TestResource.send(:parse, 'Thing' => { 'Name' => 'a' })
      expect(instance.meta.partial?).to be(false)
    end
  end
end
