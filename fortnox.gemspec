# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fortnox/version'

Gem::Specification.new do |spec|
  spec.name          = 'fortnox-api'
  spec.authors       = ['Jonas Schubert Erlandsson', 'Hannes Elvemyr', 'Felix Holmgren', 'Mike Eirih']
  spec.email         = ['info@accodeing.com']
  spec.license       = 'LGPL-3.0'
  spec.version       = Fortnox::VERSION.dup

  spec.summary       = 'Fortnox F3 REST API library, based on rest-easy.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/accodeing/fortnox'
  spec.files         = Dir['CHANGELOG.md', 'LICENSE.md', 'README.md', 'fortnox.gemspec', 'lib/**/*']
  spec.bindir        = 'bin'
  spec.executables   = ['fortnox-setup', 'fortnox-update-env']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2.0'

  spec.add_dependency 'base64'
  spec.add_dependency 'countries', '~> 7.1'
  spec.add_dependency 'dry-struct', '~> 1.5'
  spec.add_dependency 'rest-easy', '~> 1.3.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
