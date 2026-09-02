#!/bin/bash
set -eufo pipefail

cleanup() {
  local old=$1 new=$2
  if [[ -e $new && -e $old ]]; then
    echo "cleanup-xdg-migration: removing $old (superseded by $new)"
    rm -rf "$old"
  fi
}

cleanup "$HOME/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
cleanup "$HOME/.aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
cleanup "$HOME/.tmux/plugins/tmux-resurrect" "$HOME/.config/tmux/plugins/tmux-resurrect"
cleanup "$HOME/.config/fish/conf.d/init.fish" "$HOME/.config/fish/conf.d/00-init.fish"

rmdir "$HOME/.tmux/plugins" "$HOME/.tmux" 2>/dev/null || true

echo "cleanup-xdg-migration: done"