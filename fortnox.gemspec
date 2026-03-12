# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fortnox/version"

Gem::Specification.new do |spec|
  spec.name          = "rest-easy-fortnox"
  spec.authors       = ["Jonas Schubert Erlandsson", 'Hannes Elvemyr', 'Felix Holmgren', 'Mike Eirih' ,"Claude Code"]
  spec.email         = ["info@accodeing.com"]
  spec.license       = "LGPL-3.0"
  spec.version       = Fortnox::VERSION.dup

  spec.summary       = "Fortnox F3 REST API library, based on rest-easy."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/accodeing/fortnox"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "fortnox.gemspec", "lib/**/*", "config/*.yml"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1.0"

  spec.add_runtime_dependency "rest-easy", "~> 0.1.0"
  spec.add_runtime_dependency "countries"
  spec.add_runtime_dependency "dry-struct"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "faraday-net_http"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
