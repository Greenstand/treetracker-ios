[![Build Status](https://travis-ci.com/Greenstand/treetracker-ios.svg?branch=master)](https://travis-ci.com/Greenstand/treetracker-ios)

# Treetracker iOS

## Project Details

This is the iOS app for the TreeTracker open source project (www.treetracker.org).
This project coordinates tree planting employment for people living in extreme poverty.
The iOS segment allows people to track and verify reforestation plantings,
paying planters on a per planting basis.

For more on design intent and the app's user story see the [wiki in this repository](https://github.com/Greenstand/treetracker-android/wiki/User-Story)

&nbsp;

## Project Setup

### Bundler
This project uses bundler (https://bundler.io/) to manage cocoapods, fastlane and CocoapodsKeys. Use `bundle exec` when using these dependencies.

Install with `gem install bundler`

Run `bundle install` to install cocoapods, fastlane and CocoapodsKeys.

### CocoaPods
Dependencies are managed using [CocoaPods](https://guides.cocoapods.org/) and are checked into to repository.
Even though we check in the dependencies you will need to install CocoaPods to run the project as we use a plugin called CocoapodsKeys.

### CocoapodsKeys
CocoapodsKeys (https://github.com/orta/cocoapods-keys) is used to manage keys we don't want to check into the repository. We currently only use this for AWS identity pool ID's.

Then run a pod install:
`bundle exec pod install`

You will be prompted to enter AWS identity pool ID's for dev, test and production environments. Just enter anything for now, if you need to actually upload some trees to one of the environments reach out to the #ios_treetracker channel in the Greenstand slack workspace.

You could also set up your own environment on AWS. Reach out on slack if you need help with this.

### SwiftLint
[SwiftLint](https://github.com/realm/SwiftLint) is used to keep the codebase consistent. Rules can be configured or disabled in the [.swiftlint.yml](.swiftlint.yml) file.

### SwiftGen
[SwiftGen](https://github.com/SwiftGen/SwiftGen) is used to auto-generate code for resources (e.g. Storyboards, Assets, Strings etc), to make them type-safe to use. This can be configured in the [swiftgen.yml](swiftgen.yml) file.

&nbsp;

## Deployment
TBC

&nbsp;

## Contributing

See [Contributing in the Development-Overview README](https://github.com/Greenstand/Development-Overview/blob/master/README.md)

Join #ios_treetracker in the slack workspace

Review the project board for current priorities TBC

Please review the [issue tracker](https://github.com/Greenstand/treetracker-ios/issues) here on this github repository

Check out the cool [roadmap](https://github.com/Greenstand/Development-Overview/blob/master/Roadmap.md)

All contributions should be submitted as pull requests against the master branch in this github repository. https://github.com/Greenstand/treetracker-ios
