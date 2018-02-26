# frozen_string_literal: true

require 'fortnox/api/types'
require 'fortnox/api/models/base'

module Fortnox
  module API
    module Model
      class Project < Fortnox::API::Model::Base
        UNIQUE_ID = :project_number
        STUB = { description: '' }.freeze

        # Url Direct URL to the record
        attribute :url, Types::Nullable::String.with(read_only: true)

        # Comments Comments on project. 512 characters
        attribute :comments, Types::Sized::String[512]

        # ContactPerson ContactPerson for project. 50 characters
        attribute :contact_person, Types::Sized::String[50]

        # Description Description of the project. 50 characters
        attribute :description, Types::Sized::String[50]

        # EndDate End date of the project.
        attribute :end_date, Types::Nullable::Date

        # ProjectLeader Projectleader. 50 characters
        attribute :project_leader, Types::Sized::String[50]

        # ProjectNumber Projectnumber. 20 characters
        attribute :project_number, Types::Sized::String[20]

        # Status Status of the project
        attribute :status, Types::ProjectStatusType

        # StartDate Start date of the project
        attribute :start_date, Types::Nullable::Date
      end
    end
  end
end
