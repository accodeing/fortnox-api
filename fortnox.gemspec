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
  spec.description   = <<~DESCRIPTION
    Fortnox's REST API wraps every payload in a type key, spells its
    attributes in PascalCase, and treats an empty string as "leave this
    field alone" when you meant to clear it. This gem turns it into
    ordinary immutable Ruby objects with typed, constrained attributes,
    so a value Fortnox would reject raises before it costs an API call,
    and authorization, pagination and JSON mapping are handled for you.
  DESCRIPTION
  spec.homepage      = 'https://github.com/accodeing/fortnox'
  spec.files         = Dir['CHANGELOG.md', 'LICENSE.md', 'MIGRATING_TO_1.0.md', 'README.md',
                           'fortnox.gemspec', 'lib/**/*']
  spec.bindir        = 'bin'
  spec.executables   = ['fortnox-setup', 'fortnox-update-env']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2.0'

  spec.add_dependency 'base64', '~> 0.2'
  spec.add_dependency 'countries', '~> 7.1'
  spec.add_dependency 'dry-struct', '~> 1.5'
  spec.add_dependency 'rest-easy', '~> 1.4.2'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
