lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/rename_android/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-rename_android'
  spec.version       = Fastlane::RenameAndroid::VERSION
  spec.authors       = ['Josh Holtz', 'Sourcetoad']
  spec.email         = 'info@sourcetoad.com'

  spec.summary       = 'Renames Android package for .java, .kt, AndroidManifest.xml, and build.gradle files'
  spec.homepage      = "https://github.com/sourcetoad/fastlane-plugin-rename_android"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'
end
