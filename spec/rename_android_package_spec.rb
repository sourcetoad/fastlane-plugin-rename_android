require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe Fastlane::Actions::RenameAndroidAction do
  describe '#run' do
    let(:test_path) { Dir.mktmpdir }
    let(:old_package) { 'com.old.package' }
    let(:new_package) { 'com.new.package' }
    let(:old_path) { "#{test_path}/app/src/main/java/#{old_package.gsub('.', '/')}" }
    let(:new_path) { "#{test_path}/app/src/main/java/#{new_package.gsub('.', '/')}" }

    before do
      # Set up test directory structure
      FileUtils.mkdir_p(old_path)

      # Create test files
      File.write("#{old_path}/MainActivity.java", "package #{old_package};")
      File.write("#{old_path}/Helper.kt", "package #{old_package}")
      File.write("#{test_path}/app/src/main/AndroidManifest.xml",
                 "<?xml version=\"1.0\"?>\n<manifest package=\"#{old_package}\">")
      File.write("#{test_path}/app/build.gradle",
                 "applicationId \"#{old_package}\"")

      # Mock shell commands
      allow(Fastlane::Actions::RenameAndroidAction).to receive(:sh) do |command|
        if command.include?("sed")
          if command.include?(".java")
            java_content = File.read("#{new_path}/MainActivity.java")
            File.write("#{new_path}/MainActivity.java",
                       java_content.gsub(old_package, new_package))
          elsif command.include?(".kt")
            kotlin_content = File.read("#{new_path}/Helper.kt")
            File.write("#{new_path}/Helper.kt",
                       kotlin_content.gsub(old_package, new_package))
          elsif command.include?("AndroidManifest.xml")
            manifest_content = File.read("#{test_path}/app/src/main/AndroidManifest.xml")
            File.write("#{test_path}/app/src/main/AndroidManifest.xml",
                       manifest_content.gsub(old_package, new_package))
          elsif command.include?("build.gradle")
            gradle_content = File.read("#{test_path}/app/build.gradle")
            File.write("#{test_path}/app/build.gradle",
                       gradle_content.gsub(old_package, new_package))
          end
        end
      end

      # Mock Bundler.with_unbundled_env
      allow(Bundler).to receive(:with_unbundled_env).and_yield
    end

    after do
      FileUtils.remove_entry(test_path)
    end

    it 'moves files to new package directory' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: new_package
      }

      Fastlane::Actions::RenameAndroidAction.run(params)

      expect(File.exist?("#{new_path}/MainActivity.java")).to be true
      expect(File.exist?("#{new_path}/Helper.kt")).to be true
      expect(File.exist?("#{old_path}/MainActivity.java")).to be false
      expect(File.exist?("#{old_path}/Helper.kt")).to be false
    end

    it 'updates package names in Java files' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: new_package
      }

      Fastlane::Actions::RenameAndroidAction.run(params)

      java_content = File.read("#{new_path}/MainActivity.java")
      expect(java_content).to include("package #{new_package};")
      expect(java_content).not_to include("package #{old_package};")
    end

    it 'updates package names in Kotlin files' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: new_package
      }

      Fastlane::Actions::RenameAndroidAction.run(params)

      kotlin_content = File.read("#{new_path}/Helper.kt")
      expect(kotlin_content).to include("package #{new_package}")
      expect(kotlin_content).not_to include("package #{old_package}")
    end

    it 'updates AndroidManifest.xml' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: new_package
      }

      Fastlane::Actions::RenameAndroidAction.run(params)

      manifest_content = File.read("#{test_path}/app/src/main/AndroidManifest.xml")
      expect(manifest_content).to include("package=\"#{new_package}\"")
      expect(manifest_content).not_to include("package=\"#{old_package}\"")
    end

    it 'updates build.gradle' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: new_package
      }

      Fastlane::Actions::RenameAndroidAction.run(params)

      gradle_content = File.read("#{test_path}/app/build.gradle")
      expect(gradle_content).to include("applicationId \"#{new_package}\"")
      expect(gradle_content).not_to include("applicationId \"#{old_package}\"")
    end

    it 'raises an error when path is nil' do
      params = {
        path: nil,
        package_name: old_package,
        new_package_name: new_package
      }

      expect do
        Fastlane::Actions::RenameAndroidAction.run(params)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, "No path provided")
    end

    it 'raises an error when package_name is nil' do
      params = {
        path: test_path,
        package_name: nil,
        new_package_name: new_package
      }

      expect do
        Fastlane::Actions::RenameAndroidAction.run(params)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, "No package_name provided")
    end

    it 'raises an error when new_package_name is nil' do
      params = {
        path: test_path,
        package_name: old_package,
        new_package_name: nil
      }

      expect do
        Fastlane::Actions::RenameAndroidAction.run(params)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, "No new_package_name provided")
    end
  end

  describe '.is_supported?' do
    it 'returns true for android platform' do
      expect(Fastlane::Actions::RenameAndroidAction.is_supported?(:android)).to be true
    end

    it 'returns false for other platforms' do
      expect(Fastlane::Actions::RenameAndroidAction.is_supported?(:ios)).to be false
      expect(Fastlane::Actions::RenameAndroidAction.is_supported?(:mac)).to be false
    end
  end
end
