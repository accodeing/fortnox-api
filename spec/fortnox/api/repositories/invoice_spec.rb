require 'spec_helper'
require 'fortnox/api/repositories/contexts/environment'
require 'fortnox/api/repositories/invoice'
require 'fortnox/api/repositories/examples/all'
require 'fortnox/api/repositories/examples/find'
require 'fortnox/api/repositories/examples/save'

describe Fortnox::API::Repository::Invoice do
  include_context 'environment'

  include_examples '.all'

  include_examples '.find'

  include_examples '.save', :comments, { customer_number: 1 }

  describe 'writer private' do
    let( :repository ){ described_class.new }
    let( :vcr_dir ){ repository.options.json_collection_wrapper.downcase }
    subject do
      VCR.use_cassette( "#{vcr_dir}/find_id_1" ) do
        repository.find( 1 ).total
      end
    end

    it{ is_expected.to eql( 100 ) }
  end
end
