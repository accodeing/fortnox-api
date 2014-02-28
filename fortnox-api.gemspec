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
  spec.description   = "This gem uses an HTTP library to abstract the REST calls from everyday use. Simply use the builtin classes to create, access, update and destroy entries in your Fortnox database."
  spec.homepage      = "http://github.com/my-codeworks/fortnox-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
