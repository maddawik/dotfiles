#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

TN_FG=0xffc8d3f5
TN_MUTED=0xff828bb8

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.border_color=0xff82aaff \
    icon.color="$TN_FG"
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    background.border_color=0x0082aaff \
    icon.color="$TN_MUTED"
fi
