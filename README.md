# Analog App

Architecture: MVVM

## Setup
If you don't have brew:
1. Run `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

If you don't have carthage
1. Run `brew install carthage`

Otherwise setup as follows:
1. Clone repository
2. Run `carthage bootstrap --platform iOS`
Tip) If this fails, this resolved it for me `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
3. Run `pod install`
Tip) If your terminal doesnt know pod, run `sudo gem install cocoapods`
3. Open `Analog.xcworkspace`

## Localization

Update localization by running `./Localization.sh`.

This fetches and stores the localized dictionary from Loco in the project. Run this script whenever new entities have been added to Loco.
