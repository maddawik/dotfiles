#!/bin/bash
set -eufo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "migrate-kube-xdg: kubectl not installed, skipping" >&2
  exit 0
fi

SRC="$HOME/.kube"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/kube"
BACKUP="$HOME/.kube-xdg-migration-backup"

mkdir -p "$DEST"

moved=0
if [[ -e "$SRC/config" && ! -e "$DEST/config" ]]; then
  mkdir -p "$BACKUP"
  cp -a "$SRC/config" "$BACKUP/config"
  mv "$SRC/config" "$DEST/config"
  moved=1
fi

if [[ "$moved" -eq 1 ]]; then
  echo "migrate-kube-xdg: moved config to $DEST (backup: $BACKUP)"
else
  echo "migrate-kube-xdg: nothing to migrate, already in place"
fi
