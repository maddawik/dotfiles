#!/bin/bash
set -eufo pipefail

if ! command -v aws >/dev/null 2>&1; then
  echo "migrate-aws-xdg: aws not installed, skipping" >&2
  exit 0
fi

SRC="$HOME/.aws"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/aws"
BACKUP="$HOME/.aws-xdg-migration-backup"

mkdir -p "$DEST"

moved=0
for item in config credentials; do
  if [[ -e "$SRC/$item" && ! -e "$DEST/$item" ]]; then
    mkdir -p "$BACKUP"
    cp -a "$SRC/$item" "$BACKUP/$item"
    mv "$SRC/$item" "$DEST/$item"
    moved=1
  fi
done

if [[ "$moved" -eq 1 ]]; then
  echo "migrate-aws-xdg: moved config/credentials to $DEST (backup: $BACKUP)"
else
  echo "migrate-aws-xdg: nothing to migrate, already in place"
fi
