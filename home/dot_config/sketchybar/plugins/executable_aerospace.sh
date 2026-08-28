#!/usr/bin/env bash

# Updates every workspace indicator in one batched pass.
# States: focused (pill) / occupied (blue) / empty (slate).

TN_FG=0xffc8d3f5
TN_COMMENT=0xff636da6
TN_BLUE=0xff82aaff
BORDER_OFF=0x0082aaff

FOCUSED="$FOCUSED_WORKSPACE"
[ -z "$FOCUSED" ] && FOCUSED="$(aerospace list-workspaces --focused 2>/dev/null)"

OCCUPIED=" $(aerospace list-windows --all --format '%{workspace}' 2>/dev/null | sort -u | tr '\n' ' ')"

args=()
for sid in "$@"; do
  if [ "$sid" = "$FOCUSED" ]; then
    args+=(--set "space.$sid" background.drawing=on background.border_color=$TN_BLUE icon.color=$TN_FG)
  elif [[ "$OCCUPIED" == *" $sid "* ]]; then
    args+=(--set "space.$sid" background.drawing=off background.border_color=$BORDER_OFF icon.color=$TN_BLUE)
  else
    args+=(--set "space.$sid" background.drawing=off background.border_color=$BORDER_OFF icon.color=$TN_COMMENT)
  fi
done

[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"
