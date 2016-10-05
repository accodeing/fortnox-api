module Matchers
  module Model
    def have_house_work_type( attribute, valid_hash = {} )
      EnumMatcher.new( attribute, valid_hash, 'house work type', 'HouseWorkType', 'HouseWorkTypes' )
    end
  end
end
