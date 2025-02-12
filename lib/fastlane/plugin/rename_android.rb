require 'fastlane/plugin/rename_android/version'

module Fastlane
  module RenameAndroid
    # Return all .rb files inside the "actions" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default, we want to import all available actions
Fastlane::RenameAndroid.all_classes.each do |current|
  require current
end
