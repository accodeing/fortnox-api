module Matchers
  module Model
    def have_house_work_type( attribute, valid_hash = {} )
      HaveHouseWorkType.new( attribute, valid_hash )
    end

    class HaveHouseWorkType < EnumMatcher
      def initialize( attribute, valid_hash )
        super( attribute, valid_hash, 'house work type', 'HouseWorkType', 'HouseWorkTypes' )
      end
    end
  end
end
