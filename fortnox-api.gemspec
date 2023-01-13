# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/fortnox/api/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'fortnox-api'
  spec.version       = Fortnox::API::VERSION
  spec.authors       = ['Jonas Schubert Erlandsson', 'Hannes Elvemyr', 'Felix Holmgren']
  spec.email         = ['info@accodeing.com']
  spec.summary       = 'Gem to use Fortnox REST API in Ruby.'
  spec.description   = 'This gem uses the HTTParty library to abstract away the REST calls. It gives you access to a '\
                       'number of objects that behave a lot like ActiveRecord instances, giving you access to methods '\
                       'like `all`, `find`, `find_by_...` and so on. And each individual instance can be easily'\
                       'persistable to Fortnox again using the `save` method.'
  spec.homepage      = 'http://github.com/accodeing/fortnox-api'
  spec.license       = 'LGPL-3.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.7'
  spec.add_dependency 'countries', '~> 5.2'
  spec.add_dependency 'dry-configurable', '~> 1.0.1'
  spec.add_dependency 'dry-container', '~> 0.11.0'
  spec.add_dependency 'dry-struct', '~> 1.6.0'
  spec.add_dependency 'dry-types', '~> 1.7.0'
  spec.add_dependency 'httparty', '~> 0.17.3'
  spec.add_dependency 'jwt', '~> 2.6.0'

  spec.add_development_dependency 'bundler', '>= 2.4'
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'rake', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 1.42.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.16.0'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'timecop', '~> 0.9.6'
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'webmock', '~> 3.18'
end
