require "fortnox/api/models/base"

module Fortnox
  module API
    module Entities
      module Account
        class Entity < Fortnox::API::Entities::Base

          # Direct URL to the record
          attribute :url, String

          # If the account is actve
          attribute :acitve, Boolean

          # Opening balance of the account
          attribute :balancebroughtforward, Float

          # Closing balance of the account
          attribute :balancecarriedforward, Float

          # Code of the proposed cost center. The code must be of an existing cost center.
          attribute :costcenter, String

          # Cost center settings for the account. Can be ALLOWED MANDATORY or NOTALLOWED
          attribute :costcentersettings, String

          # Account description
          attribute :description, String

          # Account number
          attribute :number, Integer

          # Number of the proposed project. The number must be of an existing project.
          attribute :project, Integer

          # Project settings for the account. Can be ALLOWED MANDATORY or NOTALLOWED
          attribute :projectsettings, String

          # SRU code
          attribute :sru, String

          # Proposed transaction information
          attribute :transactioninformation, String

          # Transaction information settings for the account. Can be ALLOWED MANDATORY or NOTALLOWED
          attribute :transactioninformationsettings, String

          # VAT code
          attribute :vatcode, String

          # Id of the financial year.
          attribute :year, Integer

        end
      end
    end
  end
end

