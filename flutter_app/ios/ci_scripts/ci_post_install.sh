#!/bin/sh

if [ "$ENV" = "" ]; then
  echo "ENV is required"
  exit 1
fi

if [ "$CI_VIEWER_SA_BASE64" = "" ]; then
  echo "CI_VIEWER_SA_BASE64 is required"
  exit 1
fi

cd "$CI_WORKSPACE/environments"
source ./load.sh "$ENV"

cd "$CI_WORKSPACE/flutter" || exit

# Run make config
brew install python@$PYTHON_VERSION

export PATH="$PATH:$(brew --prefix)/opt/python@$PYTHON_VERSION/libexec/bin"

GOOGLE_APPLICATION_CREDENTIALS="$HOME"/ci_viewer_sa_credentials.json
echo "$CI_VIEWER_SA_BASE64" | base64 -d >"$GOOGLE_APPLICATION_CREDENTIALS"
GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS ANDROID_PACKAGE_NAME="" IOS_BUNDLE_ID=$IOS_BUNDLE_ID make config

echo '<debug>'
cat .env.ios
echo '</debug>'

# Set mobile app version
MOBILEAPP_TAG_PREFIX=mobileapp-$ENV-v
if [ "$ENV" = "production" ]; then
  MOBILEAPP_TAG_PREFIX=mobileapp-v
fi
MOBILEAPP_VERSION=$(echo "$CI_TAG" | sed "s/^$MOBILEAPP_TAG_PREFIX//")
sed -i '' "s/^version: .*/version: $MOBILEAPP_VERSION/" pubspec.yaml # sed on macOS need '' after -i

echo '<debug>'
cat pubspec.yaml
echo '</debug>'

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_VERSION "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0