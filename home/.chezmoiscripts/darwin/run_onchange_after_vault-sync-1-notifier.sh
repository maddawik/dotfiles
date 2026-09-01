#!/bin/bash
# Rebundle terminal-notifier as "Vault Sync" so notifications carry their own
# name, icon, and row in System Settings > Notifications instead of being
# attributed to Script Editor or terminal-notifier.
set -eufo pipefail

SRC=/opt/homebrew/opt/terminal-notifier/terminal-notifier.app
APP="$HOME/Applications/Vault Sync.app"
PLIST="$APP/Contents/Info.plist"
BUDDY=/usr/libexec/PlistBuddy
LSREGISTER=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

if [[ ! -d "$SRC" ]]; then
  echo "vault-sync: terminal-notifier not installed, skipping notifier bundle" >&2
  exit 0
fi

mkdir -p "$HOME/Applications"
rm -rf "$APP"
cp -R "$SRC" "$APP"

"$BUDDY" -c "Set :CFBundleIdentifier com.maddawik.vault-sync.notifier" "$PLIST"
"$BUDDY" -c "Set :CFBundleName Vault Sync" "$PLIST"

# The icon is cosmetic: never let a missing tool abort `chezmoi apply`.
if command -v magick >/dev/null 2>&1 && [[ -x /usr/bin/iconutil ]]; then
  # tokyonight-moon: #222436 ground, #82aaff glyph
  TMP=$(mktemp -d)
  ICONSET="$TMP/VaultSync.iconset"
  mkdir -p "$ICONSET"
  magick -size 1024x1024 xc:none \
    -fill "#222436" -draw "roundrectangle 8,8 1015,1015 232,232" \
    -stroke "#82aaff" -strokewidth 78 -fill none \
    -draw "stroke-linecap butt arc 300,300 724,724 20,160" \
    -draw "stroke-linecap butt arc 300,300 724,724 200,340" \
    -stroke none -fill "#82aaff" \
    -draw "polygon 280,495 384,580 256,627" \
    -draw "polygon 744,529 640,444 768,397" \
    "$ICONSET/icon_512x512@2x.png"

  for spec in 16:icon_16x16 32:icon_16x16@2x 32:icon_32x32 64:icon_32x32@2x \
              128:icon_128x128 256:icon_128x128@2x 256:icon_256x256 \
              512:icon_256x256@2x 512:icon_512x512; do
    px=${spec%%:*}
    magick "$ICONSET/icon_512x512@2x.png" -resize "${px}x${px}" "$ICONSET/${spec#*:}.png"
  done

  iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/VaultSync.icns"
  rm -rf "$TMP"

  "$BUDDY" -c "Set :CFBundleIconFile VaultSync" "$PLIST"
  rm -f "$APP/Contents/Resources/Terminal.icns"
else
  echo "vault-sync: imagemagick/iconutil unavailable, keeping stock icon" >&2
fi

# Editing Info.plist breaks the seal; the original is only ad-hoc signed, so
# re-signing ad-hoc is all that's needed.
codesign --force --sign - "$APP"

[[ -x "$LSREGISTER" ]] && "$LSREGISTER" -f "$APP" || true

echo "vault-sync: built $APP"