require 'spec_helper'
require 'fileutils'
require 'tmpdir'
require 'ox'

describe Fastlane::Actions::RenameAndroidAppNameAction do
  describe '#run' do
    let(:test_path) { Dir.mktmpdir }
    let(:manifest_path) { "#{test_path}/AndroidManifest.xml" }
    let(:original_name) { 'OriginalApp' }
    let(:new_name) { 'NewApp' }

    let(:manifest_xml) do
      <<~XML
        <?xml version="1.0" encoding="utf-8"?>
        <manifest xmlns:android="http://schemas.android.com/apk/res/android"
            package="com.example.app">
            <application
                android:label="#{original_name}"
                android:icon="@mipmap/ic_launcher">
                <activity android:name=".MainActivity" />
            </application>
        </manifest>
      XML
    end

    before do
      File.write(manifest_path, manifest_xml)
    end

    after do
      FileUtils.remove_entry(test_path)
    end

    it 'updates the app name in the manifest' do
      params = { new_name: new_name, manifest: manifest_path }

      Fastlane::Actions::RenameAndroidAppNameAction.run(params)

      updated_xml = File.read(manifest_path)
      expect(updated_xml).to include(new_name)
      expect(updated_xml).not_to include("android:label=\"#{original_name}\"")
    end

    it 'produces valid XML after updating' do
      params = { new_name: new_name, manifest: manifest_path }

      Fastlane::Actions::RenameAndroidAppNameAction.run(params)

      updated_xml = File.read(manifest_path)
      expect { Ox.parse(updated_xml) }.not_to raise_error
    end

    it 'preserves other attributes in the application element' do
      params = { new_name: new_name, manifest: manifest_path }

      Fastlane::Actions::RenameAndroidAppNameAction.run(params)

      updated_xml = File.read(manifest_path)
      expect(updated_xml).to include('@mipmap/ic_launcher')
    end

    it 'preserves child elements of the manifest' do
      params = { new_name: new_name, manifest: manifest_path }

      Fastlane::Actions::RenameAndroidAppNameAction.run(params)

      updated_xml = File.read(manifest_path)
      expect(updated_xml).to include('.MainActivity')
    end

    it 'handles a manifest with no application element gracefully' do
      minimal_xml = <<~XML
        <?xml version="1.0" encoding="utf-8"?>
        <manifest xmlns:android="http://schemas.android.com/apk/res/android"
            package="com.example.app">
        </manifest>
      XML
      File.write(manifest_path, minimal_xml)

      params = { new_name: new_name, manifest: manifest_path }

      expect { Fastlane::Actions::RenameAndroidAppNameAction.run(params) }.not_to raise_error
    end

    it 'handles special characters in the new name' do
      special_name = "My App & \"Friends\" <3"
      params = { new_name: special_name, manifest: manifest_path }

      Fastlane::Actions::RenameAndroidAppNameAction.run(params)

      updated_xml = File.read(manifest_path)
      expect { Ox.parse(updated_xml) }.not_to raise_error
    end
  end

  describe '.find_elements' do
    it 'finds deeply nested elements by name' do
      xml = <<~XML
        <root>
          <parent>
            <target>found</target>
          </parent>
        </root>
      XML
      doc = Ox.parse(xml)

      results = Fastlane::Actions::RenameAndroidAppNameAction.find_elements(doc, 'target')
      expect(results.length).to eq(1)
      expect(results.first.name).to eq('target')
    end

    it 'finds multiple elements with the same name' do
      xml = <<~XML
        <root>
          <item>first</item>
          <item>second</item>
        </root>
      XML
      doc = Ox.parse(xml)

      results = Fastlane::Actions::RenameAndroidAppNameAction.find_elements(doc, 'item')
      expect(results.length).to eq(2)
    end

    it 'returns empty array when element is not found' do
      xml = '<root><other>value</other></root>'
      doc = Ox.parse(xml)

      results = Fastlane::Actions::RenameAndroidAppNameAction.find_elements(doc, 'missing')
      expect(results).to be_empty
    end
  end

  describe '.is_supported?' do
    it 'returns true for android platform' do
      expect(Fastlane::Actions::RenameAndroidAppNameAction.is_supported?(:android)).to be true
    end

    it 'returns false for other platforms' do
      expect(Fastlane::Actions::RenameAndroidAppNameAction.is_supported?(:ios)).to be false
      expect(Fastlane::Actions::RenameAndroidAppNameAction.is_supported?(:mac)).to be false
    end
  end
end
