require 'spec_helper'
require 'fortnox/api/models/default_delivery_types'

RSpec.describe Fortnox::API::Model::DefaultDeliveryTypes, type: :model do
  subject{ described_class }

  it{ is_expected.to have_default_delivery_type( :invoice ) }
  it{ is_expected.to have_default_delivery_type( :order ) }
  it{ is_expected.to have_default_delivery_type( :offer ) }
end
