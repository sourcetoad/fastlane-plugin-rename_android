# Originally based off of  https://github.com/MaximusMcCann/fastlane-plugin-android_change_app_name
# Updated to use Ox XML parser instead of Nokogiri.
# Removed the reverting functionality.

module Fastlane
  module Actions
    class AndroidChangeNameAction < Action
      def self.run(params)
        require 'ox'

        newName = params[:newName]
        manifest = params[:manifest]

        xml = File.read(manifest)
        doc = Ox.parse(xml)

        find_elements(doc, 'application').each do |app_node|
          app_node['android:label'] = newName
          UI.message("Updating app name to: #{newName}")
        end

        File.write(manifest, Ox.dump(doc, indent: 2))
      end

      def self.find_elements(node, name)
        results = []
        return results unless node.respond_to?(:nodes)

        node.nodes.each do |child|
          next unless child.kind_of?(Ox::Element)

          results << child if child.name == name
          results.concat(find_elements(child, name))
        end
        results
      end

      def self.description
        "Changes the manifest's label attribute (appName)."
      end

      def self.authors
        ["Sourcetoad"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Changes the apk manifest file's label attribute (appName)."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :newName,
                                       env_name: "FL_RENAME_ANDROID_PACKAGE_NEW_APP_NAME",
                                       description: "The new name for the app",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :manifest,
                                       env_name: "FL_RENAME_ANDROID_PACKAGE_ANDROID_MANIFEST_PATH",
                                       description: "Optional custom location for AndroidManifest.xml",
                                       optional: false,
                                       type: String,
                                       default_value: "app/src/main/AndroidManifest.xml")
        ]
      end

      def self.output
        []
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
