# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fortnox/api/version'

Gem::Specification.new do |spec|
  spec.name          = "fortnox-api"
  spec.version       = Fortnox::API::VERSION
  spec.authors       = ["Jonas Schubert Erlandsson"]
  spec.email         = ["jonas.schubert.erlandsson@my-codeworks.com"]
  spec.summary       = "Gem to use Fortnox REST API in Ruby."
  spec.description   = "This gem uses the HTTParty library to abstract away the REST calls. It gives you access to a number of objects that behave a lot like ActiveRecord instances, giving you access to methods like `all`, `find`, `find_by_...` and so on. And each individual instance can be easaly persistable to Fortnox again using the `save` method."
  spec.homepage      = "http://github.com/my-codeworks/fortnox-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13"
  spec.add_dependency "dotenv", "~> 2.0"
  spec.add_dependency "virtus", "~> 1.0"
  spec.add_dependency "vanguard", "~> 0.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
  spec.add_development_dependency "webmock", "~> 1.21"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "codeclimate-test-reporter"

end
