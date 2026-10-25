#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")"
if ! xcrun --find swiftc >/dev/null 2>&1; then
  echo "Apple's Xcode Command Line Tools are required. Install with: xcode-select --install"
  exit 1
fi
APP="$PWD/Crown Control.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>Crown Control</string>
  <key>CFBundleDisplayName</key><string>Crown Control</string>
  <key>CFBundleIdentifier</key><string>uk.local.crowncontrol</string>
  <key>CFBundleExecutable</key><string>CrownControl</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
xcrun swiftc -O -framework AppKit CrownControl.swift -o "$APP/Contents/MacOS/CrownControl"
# An ad-hoc signature is applied locally; it is not an Apple notarisation.
codesign --force --sign - "$APP"
echo "Built: $APP"
echo "You can move 'Crown Control.app' into Applications, then open it."
