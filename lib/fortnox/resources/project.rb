# frozen_string_literal: true

module Fortnox
  class Project < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'projects'
      instance_wrapper 'Project'
      collection_wrapper 'Projects'
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', Coercible::String.optional, :read_only

    # Comments Comments on project. 512 characters
    attr :comments, Sized::String[512]

    # ContactPerson ContactPerson for project. 50 characters
    attr :contact_person, Sized::String[50]

    # Description Description of the project. 50 characters
    attr :description, Sized::String[50]

    # EndDate End date of the project.
    attr :end_date, Date.optional, Parsers: Date

    # ProjectLeader Projectleader. 50 characters
    attr :project_leader, Sized::String[50]

    # ProjectNumber Projectnumber. 20 characters
    key :project_number, Sized::String[20]

    # Status Status of the project
    attr :status, ProjectStatusTypes

    # StartDate Start date of the project
    attr :start_date, Date.optional, Parsers: Date
  end
end
