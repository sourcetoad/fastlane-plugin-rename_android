require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Actions
    class RenameAndroidAction < Action
      def self.run(params)
        UI.user_error!("No path provided") if params[:path].nil?
        UI.user_error!("No package_name provided") if params[:package_name].nil?
        UI.user_error!("No new_package_name provided") if params[:new_package_name].nil?

        path = params[:path]
        package_name = params[:package_name]
        new_package_name = params[:new_package_name]

        folder = package_name.gsub('.', '/')
        new_folder = new_package_name.gsub('.', '/')
        new_folder_path = "#{path}/app/src/main/java/#{new_folder}"

        FileUtils.mkdir_p(new_folder_path)

        java_sources = Dir.glob("#{path}/app/src/main/java/#{folder}/*.java")
        java_sources.each do |file|
          FileUtils.mv(file, new_folder_path)
        end

        kotlin_sources = Dir.glob("#{path}/app/src/main/java/#{folder}/*.kt")
        kotlin_sources.each do |file|
          FileUtils.mv(file, new_folder_path)
        end

        # Determine the correct sed command based on OSTYPE
        if RUBY_PLATFORM.include?('darwin')
          sed_command = "sed -i ''"
        else
          sed_command = "sed -i"
        end

        Bundler.with_clean_env do
          sh("find #{path}/app/src -name '*.java' -type f -exec #{sed_command} 's/#{package_name}/#{new_package_name}/g' {} +")
          sh("find #{path}/app/src -name '*.kt' -type f -exec #{sed_command} 's/#{package_name}/#{new_package_name}/g' {} +")
          sh("find #{path}/app/src -name 'AndroidManifest.xml' -type f -exec #{sed_command} 's/#{package_name}/#{new_package_name}/g' {} +")
          sh("find #{path}/app -name 'build.gradle' -type f -exec #{sed_command} 's/#{package_name}/#{new_package_name}/g' {} +")
        end
      end

      def self.description
        "Renames Android package for .java, .kt, AndroidManifest.xml, and build.gradle files"
      end

      def self.authors
        %w[joshdholtz sourcetoad]
      end

      def self.details
        "Renames Android package"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "FL_RENAME_ANDROID_PACKAGE_PATH",
                                       description: "Path of root Android project folder",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :package_name,
                                       env_name: "FL_RENAME_ANDROID_PACKAGE_PACKAGE_NAME",
                                       description: "Old package name",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :new_package_name,
                                       env_name: "FL_RENAME_ANDROID_PACKAGE_NEW_PACKAGE_NAME",
                                       description: "New package name",
                                       is_string: true)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
