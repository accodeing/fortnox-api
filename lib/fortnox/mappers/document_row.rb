# frozen_string_literal: true

module Fortnox
  module Mappers
    class DocumentRow < Struct
      struct    Structs::DocumentRow
      overrides housework: 'HouseWork',
                housework_hours_to_report: 'HouseWorkHoursToReport',
                housework_type: 'HouseWorkType',
                vat: 'VAT'
    end
  end
end
