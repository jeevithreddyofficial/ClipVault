#!/usr/bin/env bash
# Builds ClipVault.app using only swiftc — no Xcode project required.
set -euo pipefail
cd "$(dirname "$0")"

APP="ClipVault.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc -O \
  -target "$(uname -m)-apple-macos13.0" \
  -framework AppKit -framework ServiceManagement \
  Sources/main.swift \
  -o "$APP/Contents/MacOS/ClipVault"

cp Resources/Info.plist "$APP/Contents/Info.plist"

# Ad-hoc sign so macOS will launch it locally.
codesign --force --sign - "$APP" >/dev/null 2>&1 || true

echo "✅ Built $APP — run: open $APP"
