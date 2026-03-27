# rename_android fastlane plugin
_Forked from [joshdholtz/fastlane-plugin-rename_android_package](https://github.com/joshdholtz/fastlane-plugin-rename_android_package) due to abandonment._

[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-rename_android.svg)](https://badge.fury.io/rb/fastlane-plugin-rename_android)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-rename_android`, add it to your project by running:

```bash
fastlane add_plugin rename_android
```

## Actions

### rename_android

Renames the Android package name across `.java`, `.kt`, `AndroidManifest.xml`, and `build.gradle` files.

```rb
rename_android(
  path: "./",
  package_name: "com.example.oldapp",
  new_package_name: "com.example.newapp"
)
```

| Parameter | Description | Required | Default |
|---|---|---|---|
| `path` | Path to the Android project root | Yes | |
| `package_name` | The current package name | Yes | |
| `new_package_name` | The new package name | Yes | |

### rename_android_app_name

Changes the `android:label` attribute in the `AndroidManifest.xml` file. This is the display name of the app.

```rb
rename_android_app_name(
  new_name: "My New App Name",
  manifest: "app/src/main/AndroidManifest.xml"
)
```

| Parameter | Description | Required | Default |
|---|---|---|---|
| `new_name` | The new display name for the app | No | |
| `manifest` | Path to the AndroidManifest.xml file | No | `app/src/main/AndroidManifest.xml` |

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
