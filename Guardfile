# frozen_string_literal: true

group :focus_rspec do
  guard :rspec, cmd: 'bundle exec rspec --color', all_after_pass: true do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { 'spec' }
  end
end

group :focus_rubocop do
  guard :rubocop, cli: ['--parallel'] do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
