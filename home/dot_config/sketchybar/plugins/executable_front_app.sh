#!/usr/bin/env bash

# Shows the frontmost app's name plus its icon from sketchybar-app-font.
#
# icon_map.sh maps an app name to a ligature token like ":ghostty:", which the
# sketchybar-app-font renders as the icon -- so the icon item's font must be
# that font, not the Nerd Font used elsewhere. Unknown apps map to ":default:".

source "$CONFIG_DIR/plugins/icon_map.sh"

APP="$INFO"

# On --reload/--update there is no $INFO, so ask the window server directly.
if [ -z "$APP" ]; then
  APP=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | sed 's/.*"=*"\(.*\)"/\1/')
fi

[ -z "$APP" ] && exit 0

__icon_map "$APP"

sketchybar --set "$NAME" label="$APP" icon="$icon_result"
