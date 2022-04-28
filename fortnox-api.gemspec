# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fortnox/api/version'

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

  spec.required_ruby_version = '>= 2.6'
  spec.add_dependency 'countries', '~> 3.0'
  spec.add_dependency 'dry-struct', '~> 0.1'
  spec.add_dependency 'dry-types', '~> 0.8', '< 0.13.0'
  spec.add_dependency 'httparty', '~> 0.17'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 0'
  spec.add_development_dependency 'rubocop', '~> 0.62.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'
  spec.add_development_dependency 'simplecov', '~> 0.15'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.5'
end
