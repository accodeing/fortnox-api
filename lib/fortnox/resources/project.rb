# frozen_string_literal: true

module Fortnox
  class Project < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path 'projects'
      instance_wrapper 'Project'
      collection_wrapper 'Projects'
      scope 'project'
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', UnsizedString, :read_only

    # Comments Comments on project
    attr :comments, Sized::String[512]

    # ContactPerson ContactPerson for project
    attr :contact_person, Sized::String[50]

    # Description Description of the project
    attr :description, Sized::String[50]

    # EndDate End date of the project.
    attr :end_date, Date.optional, Mappers::Date

    # ProjectLeader Projectleader
    attr :project_leader, Sized::String[50]

    # ProjectNumber Projectnumber
    key :project_number, Sized::String[20]

    # Status Status of the project
    attr :status, ProjectStatusTypes

    # StartDate Start date of the project
    attr :start_date, Date.optional, Mappers::Date
  end
end
