module Matchers
  module Type
    def have_house_work_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'HouseWorkType', 'HouseWorkTypes' )
    end
  end
end
