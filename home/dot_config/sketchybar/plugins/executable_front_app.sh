#!/usr/bin/env bash

# icon_map.sh maps an app name to a ":name:" ligature for sketchybar-app-font.

source "$CONFIG_DIR/plugins/icon_map.sh"

APP="$INFO"
# No $INFO on --reload/--update.
[ -z "$APP" ] && APP=$(lsappinfo info -only name "$(lsappinfo front)" 2>/dev/null | sed 's/.*"=*"\(.*\)"/\1/')
[ -z "$APP" ] && exit 0

__icon_map "$APP"
sketchybar --set "$NAME" label="$APP" icon="$icon_result"
