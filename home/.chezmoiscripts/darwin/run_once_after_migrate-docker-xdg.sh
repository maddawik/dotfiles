#!/bin/bash
set -eufo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "migrate-docker-xdg: docker not installed, skipping" >&2
  exit 0
fi

SRC="$HOME/.docker"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/docker"
BACKUP="$HOME/.docker-xdg-migration-backup"

mkdir -p "$DEST"

moved=0
for item in config.json contexts buildx; do
  if [[ -e "$SRC/$item" && ! -e "$DEST/$item" ]]; then
    mkdir -p "$BACKUP"
    cp -a "$SRC/$item" "$BACKUP/$item"
    mv "$SRC/$item" "$DEST/$item"
    moved=1
  fi
done

if [[ -d "$SRC/cli-plugins" && ! -e "$DEST/cli-plugins" ]]; then
  ln -s "$SRC/cli-plugins" "$DEST/cli-plugins"
  moved=1
fi

if [[ "$moved" -eq 1 ]]; then
  echo "migrate-docker-xdg: moved config.json/contexts/buildx to $DEST, symlinked cli-plugins (backup: $BACKUP)"
else
  echo "migrate-docker-xdg: nothing to migrate, already in place"
fi
