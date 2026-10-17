#!/bin/bash
# Background services that brew installs but does not start.
set -eufo pipefail

# Scripts inherit the caller's PATH; a fresh zsh has no brew in it yet.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

if command -v sketchybar >/dev/null 2>&1; then
  if ! brew services list | grep -qE '^sketchybar\s+started'; then
    brew services start sketchybar
  fi
fi
echo "start-services: done"
