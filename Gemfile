source('https://rubygems.org')

gemspec

# Add development dependencies here
gem 'fastlane', '>= 2.225.0'
gem 'pry'
gem 'rake'
gem 'rspec'
gem 'rspec_junit_formatter'
gem 'rubocop', '1.50.2'
gem 'rubocop-performance'
gem 'rubocop-require_tools'
gem 'simplecov'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
