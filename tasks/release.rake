# frozen_string_literal: true

namespace :release do
  desc 'Prepare a release: bump version, update CHANGELOG, commit and tag (VERSION=x.y.z)'
  task :prepare do
    version = ENV.fetch('VERSION') { abort 'Usage: bundle exec rake release:prepare VERSION=x.y.z' }

    validate_release_preconditions!(version)
    run_specs!

    previous = read_current_version
    update_version_file!(version)
    refresh_lockfile!
    update_changelog!(version: version, previous: previous)
    commit_release!(version)

    puts
    puts "Prepared v#{version}. Run `bundle exec rake release:publish VERSION=#{version}` to publish."
  end

  desc 'Publish a prepared release: build, gem push, git push --tags (VERSION=x.y.z)'
  task :publish do
    version = ENV.fetch('VERSION') { abort 'Usage: bundle exec rake release:publish VERSION=x.y.z' }

    abort_unless_tag_exists!(version)

    sh 'gem', 'build', 'fortnox.gemspec'
    sh 'gem', 'push', "fortnox-api-#{version}.gem"
    sh 'git', 'push'
    sh 'git', 'push', '--tags'

    puts
    puts "Published v#{version}."
  end
end

def validate_release_preconditions!(version)
  abort_on_tracked_modifications!
  abort_if_tag_exists!(version)
  abort_if_unreleased_empty!
end

def commit_release!(version)
  sh 'git', 'add', 'CHANGELOG.md', 'lib/fortnox/version.rb', 'Gemfile.lock'
  sh 'git', 'commit', '-m', "Release #{version}"
  sh 'git', 'tag', "v#{version}"
end

def refresh_lockfile!
  # Re-resolve Gemfile.lock so the bumped version in version.rb propagates
  # to the `fortnox-api (X.Y.Z)` line of the lockfile. Without this the
  # release commit leaves a stale lockfile (cosmetic, but a recurring
  # follow-up commit otherwise — see c731c41 for rc9).
  sh 'bundle', 'install'
end

def abort_on_tracked_modifications!
  status = `git status --porcelain --untracked-files=no`.strip
  return if status.empty?

  abort "Refusing to release with uncommitted changes:\n#{status}"
end

def abort_if_tag_exists!(version)
  tag = "v#{version}"
  abort "Tag #{tag} already exists locally." if system("git rev-parse #{tag} >/dev/null 2>&1")

  remote = `git ls-remote --tags origin refs/tags/#{tag} 2>/dev/null`.strip
  abort "Tag #{tag} already exists on origin." unless remote.empty?
end

def abort_unless_tag_exists!(version)
  tag = "v#{version}"
  return if system("git rev-parse #{tag} >/dev/null 2>&1")

  abort "Tag #{tag} not found. Run `bundle exec rake release:prepare VERSION=#{version}` first."
end

def abort_if_unreleased_empty!
  content = File.read('CHANGELOG.md')
  match = content.match(/^## \[Unreleased\]\s*\n(.*?)(?=^## \[)/m)
  abort 'CHANGELOG.md is missing the [Unreleased] section.' unless match
  abort 'CHANGELOG.md [Unreleased] section is empty — add release notes first.' if match[1].strip.empty?
end

def run_specs!
  puts 'Running test suite...'
  abort 'Test suite failed; aborting release.' unless system('bundle', 'exec', 'rake', 'spec')
end

def read_current_version
  File.read('lib/fortnox/version.rb').match(/VERSION = '([^']+)'/)[1]
end

def update_version_file!(version)
  path = 'lib/fortnox/version.rb'
  content = File.read(path).sub(/VERSION = '[^']+'/, "VERSION = '#{version}'")
  File.write(path, content)
end

def update_changelog!(version:, previous:)
  content = File.read('CHANGELOG.md')
  content = insert_version_heading(content, version)
  content = update_compare_links(content, version, previous)
  File.write('CHANGELOG.md', content)
end

def insert_version_heading(content, version)
  today = Time.now.strftime('%Y-%m-%d')
  content.sub(/^## \[Unreleased\]\n\n/, "## [Unreleased]\n\n## [#{version}] - #{today}\n\n")
end

def update_compare_links(content, version, previous)
  base = 'https://github.com/accodeing/fortnox-api/compare'
  content.sub(
    /^\[Unreleased\]: .*?\.\.\.HEAD$/,
    "[Unreleased]: #{base}/v#{version}...HEAD\n[#{version}]: #{base}/v#{previous}...v#{version}"
  )
end
