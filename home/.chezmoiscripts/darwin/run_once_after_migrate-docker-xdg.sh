#!/bin/bash
# Docker Desktop drops its CLI-facing config (config.json, contexts, buildx
# state) into ~/.docker regardless of DOCKER_CONFIG. fish exports
# DOCKER_CONFIG=$XDG_CONFIG_HOME/docker (dot_config/fish/conf.d/xdg-apps.fish),
# so those files need to live there instead. Desktop's own app state
# (daemon.json, desktop-build, mutagen, sandboxes, models, modules, run, bin,
# .token_seed*, and the cli-plugins symlink targets) stays in ~/.docker since
# Desktop.app hardcodes that path and never sees DOCKER_CONFIG.
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