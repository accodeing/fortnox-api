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

    it 'raises Fortnox::RequestError preserving the response' do
      response = instance_double(Faraday::Response, status: 503)
      raising = -> { TestResource.send(:with_translated_errors) { raise RestEasy::RequestError, response } }
      expect(&raising).to raise_error(
        an_instance_of(Fortnox::RequestError).and(having_attributes(response: response))
      )
    end
  end
end
