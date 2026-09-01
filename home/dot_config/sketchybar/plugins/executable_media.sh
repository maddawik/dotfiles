#!/usr/bin/env bash

# Now playing. sketchybar's own media_change event is dead on macOS 15.4+
# (Apple restricted MediaRemote to entitled processes), so this reads
# media-control instead, which reaches browser audio as well as Music/Spotify.
#
#   media.sh stream   long-running; updates the item as playback changes
#   media.sh toggle   click_script

if [ "$1" = "toggle" ]; then
  exec media-control toggle-play-pause
fi

# Locate siblings from this script, not $CONFIG_DIR, which is only set when
# sketchybar invokes us.
source "$(dirname "${BASH_SOURCE[0]}")/icon_map.sh"

# Tracked by pidfile, not by pkill pattern: media-control execs perl, so its
# cmdline never says "media-control", and a -f pattern also matches any shell
# that merely mentions it.
TN_FG=0xffc8d3f5
TN_COMMENT=0xff636da6
TN_GREEN=0xffc3e88d

PIDFILE="${TMPDIR:-/tmp}/sketchybar-media.pid"
echo $$ >"$PIDFILE"
# Only clear the pidfile if it is still ours -- on reload the replacement has
# usually already written its own, and blindly removing it would leave the next
# reload with nothing to kill.
cleanup() {
  pkill -P $$ 2>/dev/null
  [ "$(cat "$PIDFILE" 2>/dev/null)" = "$$" ] && rm -f "$PIDFILE"
  return 0
}
trap cleanup EXIT
trap 'cleanup; exit 0' INT TERM

# The pipeline runs in the BACKGROUND and we wait on it: bash defers traps
# while blocked on a foreground command, so a foreground pipeline here would
# ignore SIGTERM and reloads would stack processes forever.
# --no-diff so every update carries full state; --no-artwork drops several
# hundred KB of base64 per update.
media-control stream --no-diff --no-artwork --debounce=250 2>/dev/null |
  jq --unbuffered -r '.payload | [(.playing//false|tostring), (.bundleIdentifier//""), (.title//"")] | @tsv' 2>/dev/null |
  while IFS=$'\t' read -r playing bundle title; do
    # Only hide when there is no media session at all. Hiding on pause would
    # resize the band every time playback stops.
    if [ -z "$title" ]; then
      sketchybar --set media drawing=off
      continue
    fi

    # Resolve the source app only when it changes; mdfind is slow.
    if [ "$bundle" != "$last_bundle" ]; then
      last_bundle="$bundle"
      app=$(mdfind "kMDItemCFBundleIdentifier == '$bundle'" 2>/dev/null | head -1)
      app=${app##*/}
      __icon_map "${app%.app}"
      icon="$icon_result"
    fi

    if [ "$playing" = "true" ]; then
      icon_color=$TN_GREEN label_color=$TN_FG
    else
      icon_color=$TN_COMMENT label_color=$TN_COMMENT
    fi

    sketchybar --set media drawing=on icon="$icon" label="$title" \
      icon.color="$icon_color" label.color="$label_color"
  done &

wait
