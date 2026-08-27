#!/usr/bin/env bash

# Updates every workspace indicator in one pass.
#
# Called once per event with all workspace ids as arguments, rather than once
# per workspace: querying AeroSpace per-item cost ~135ms and 5 sketchybar IPC
# round-trips on every app switch, which was visibly laggy. One query plus one
# batched --set is ~15ms.
#
# Three states, so every configured workspace stays visible but empty ones
# recede: focused -> highlighted pill; occupied -> normal; empty -> dimmed.

TN_FG=0xffc8d3f5
TN_MUTED=0xff828bb8
TN_COMMENT=0xff636da6
TN_BLUE=0xff82aaff
BORDER_OFF=0x0082aaff

# FOCUSED_WORKSPACE is only set when AeroSpace fires the trigger; on a plain
# --reload / --update it is empty, so ask AeroSpace directly.
FOCUSED="$FOCUSED_WORKSPACE"
[ -z "$FOCUSED" ] && FOCUSED="$(aerospace list-workspaces --focused 2>/dev/null)"

# Space-padded list of workspaces holding at least one window, e.g. " 1 2 4 ".
OCCUPIED=" $(aerospace list-windows --all --format '%{workspace}' 2>/dev/null | sort -u | tr '\n' ' ')"

args=()
for sid in "$@"; do
  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set "space.$sid" background.drawing=on background.border_color=$TN_BLUE icon.color=$TN_FG)
  elif [[ "$OCCUPIED" == *" $sid "* ]]; then
    args+=(--set "space.$sid" background.drawing=off background.border_color=$BORDER_OFF icon.color=$TN_MUTED)
  else
    args+=(--set "space.$sid" background.drawing=off background.border_color=$BORDER_OFF icon.color=$TN_COMMENT)
  fi
done

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
