require 'spec_helper'
require 'fortnox/api/customer'

describe Fortnox::API::Customer do
  let( :find_id ){ 1 }
  let( :find_request ) do
    VCR.use_cassette( 'customers/find_id_1' ){ described_class.find( find_id ) }
  end
  let( :model_class ){ Fortnox::API::Model::Customer }

  shared_context 'new customer' do
    let( :customer_name ){ 'A customer' }

    subject{ described_class.new( name: customer_name ) }
  end

  describe 'creation' do
    include_context 'new customer'

    specify{ expect( subject.valid? ).to be true }
  end

  shared_context 'environment' do
    before do
      ENV['FORTNOX_API_BASE_URL'] = 'http://api.fortnox.se/3'
      ENV['FORTNOX_API_CLIENT_SECRET'] = '9aBA8ZgsvR'
      ENV['FORTNOX_API_ACCESS_TOKEN'] = 'ccaef817-d5d8-4b1c-a316-54f3e55c5c54'
    end
  end

  describe '#all' do
    include_context 'environment'

    let(:response) do
      VCR.use_cassette( 'customers/all' ){ described_class.all }
    end

    specify 'returns correct number of records' do
      expect( response.size ).to be 1
    end

    specify 'returns correct class' do
      expect( response.first.class ).to be model_class
    end
  end

  describe '#find' do
    include_context 'environment'

    subject{ find_request }

    specify 'returns correct class' do
      expect( subject.class ).to be model_class
    end

    specify 'returns correct Customer' do
      expect( subject.id ).to be find_id
    end

    specify 'returned record is valid' do
      expect( subject.valid? )
    end
  end

  describe '#save' do
    include_context 'environment'

    describe 'new' do
      include_context 'new customer'

      let( :send_request ) do
        VCR.use_cassette( 'customers/save_new' ){ subject.save }
      end
      let( :response ){ send_request }

      specify 'return true' do
        expect( response ).to include('Customer')
      end

      specify 'record is saved' do
        send_request
        expect(subject).to be_saved
      end
    end

    describe 'old (update)' do
      let( :send_request ){ find_request }

      it{ puts send_request }
    end
  end
end
