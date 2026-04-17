# frozen_string_literal: true

desc 'Remove all VCR cassettes so we can rerecord them'
task :throw_vcr_cassettes do
  FileUtils.rm_rf(Dir.glob('spec/vcr_cassettes/**'))
end
