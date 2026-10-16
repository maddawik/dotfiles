#!/bin/bash
# Background services that brew installs but does not start.
set -eufo pipefail

if command -v sketchybar >/dev/null 2>&1; then
  if ! brew services list | grep -qE '^sketchybar\s+started'; then
    brew services start sketchybar
  fi
fi
echo "start-services: done"
