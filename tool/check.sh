#!/usr/bin/env bash
set -euo pipefail
echo ">>> dart format --set-exit-if-changed --output=none ."
dart format --set-exit-if-changed --output=none .
echo ">>> flutter analyze"
flutter analyze
echo ">>> flutter test"
flutter test
echo "OK"
