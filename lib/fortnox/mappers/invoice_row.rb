# frozen_string_literal: true

module Fortnox
  module Mappers
    class InvoiceRow < DocumentRow
      struct    Structs::InvoiceRow
      overrides housework: 'HouseWork',
                housework_hours_to_report: 'HouseWorkHoursToReport',
                housework_type: 'HouseWorkType',
                price_excluding_vat: 'PriceExcludingVAT',
                total_excluding_vat: 'TotalExcludingVAT'
    end
  end
end
