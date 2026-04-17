# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

Dir['tasks/**/*.rake'].each { |task| load task }
