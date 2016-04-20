require 'spec_helper'

shared_examples_for 'DocumentRow' do
  describe '.new' do
    it{ is_expected.to upcase_lower_case_for( :discount_type, 'amount' ) }
    it{ is_expected.to upcase_lower_case_for( :house_work_type, 'cooking' ) }

    it{ is_expected.to return_nil_for_invalid_types( :discount_type, 'INVALID_TYPE' ) }
    it{ is_expected.to return_nil_for_invalid_types( :house_work_type, 'INVALID_TYPE' ) }
  end
end

