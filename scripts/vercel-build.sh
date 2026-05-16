#!/usr/bin/env bash
# Builds Flutter web for Vercel (Flutter SDK is not pre-installed on Vercel runners).
set -euo pipefail

FLUTTER_HOME="${FLUTTER_HOME:-/tmp/flutter}"

if [ ! -f "${FLUTTER_HOME}/bin/flutter" ]; then
  echo "→ Installing Flutter (stable)…"
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "${FLUTTER_HOME}"
fi

export PATH="${FLUTTER_HOME}/bin:${PATH}"

flutter --version
flutter config --enable-web --no-analytics
flutter precache --web --no-android --no-ios --no-linux --no-macos --no-windows

echo "→ Resolving dependencies…"
flutter pub get

echo "→ Building web release…"
flutter build web --release --base-href /

echo "✓ Web build output: build/web"
