# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Remove all VCR cassettes so we can rerecord them'
task :throw_vcr_cassettes do
  FileUtils.rm_rf(Dir.glob('spec/vcr_cassettes/**'))
end
