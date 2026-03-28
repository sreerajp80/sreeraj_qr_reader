#!/usr/bin/env bash
# Build release APK/AAB with the current date injected as BUILD_DATE.
# Usage:
#   ./tool/build_release.sh apk
#   ./tool/build_release.sh appbundle

set -euo pipefail

BUILD_DATE=$(date +%Y-%m-%d)
TARGET=${1:-apk}

echo "Building prod $TARGET with BUILD_DATE=$BUILD_DATE"
flutter build "$TARGET" --flavor prod --release --dart-define=BUILD_DATE="$BUILD_DATE"
