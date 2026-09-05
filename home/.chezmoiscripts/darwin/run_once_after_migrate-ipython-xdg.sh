#!/bin/bash
set -eufo pipefail

if ! command -v python3 >/dev/null 2>&1; then
  echo "migrate-ipython-xdg: python3 not installed, skipping" >&2
  exit 0
fi

SRC="$HOME/.ipython"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/ipython"
BACKUP="$HOME/.ipython-xdg-migration-backup"

if [[ ! -d "$SRC" ]]; then
  echo "migrate-ipython-xdg: nothing to migrate, already in place"
  exit 0
fi

mkdir -p "$DEST"

# Enumerate with find rather than a glob: `set -f` above disables globbing,
# and profile names aren't known in advance (profile_default, profile_foo, ...).
moved=0
while IFS= read -r -d '' item; do
  name="$(basename "$item")"
  if [[ ! -e "$DEST/$name" ]]; then
    mkdir -p "$BACKUP"
    cp -a "$item" "$BACKUP/$name"
    mv "$item" "$DEST/$name"
    moved=1
  fi
done < <(find "$SRC" -mindepth 1 -maxdepth 1 -print0)

if [[ "$moved" -eq 1 ]]; then
  rmdir "$SRC" 2>/dev/null || true
  echo "migrate-ipython-xdg: moved profile data to $DEST (backup: $BACKUP)"
else
  echo "migrate-ipython-xdg: nothing to migrate, already in place"
fi
