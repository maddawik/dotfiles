#!/usr/bin/env sh

CPU_LINE="$(top -l 1 -n 0 | grep -E "^CPU usage:" | head -n 1)"

IDLE="$(echo "$CPU_LINE" | awk -F'[:, ]+' '
  { for (i=1; i<=NF; i++) if ($i ~ /idle/) { print $(i-1); exit } }
' | tr -d '%' | tr ',' '.')"

USAGE="$(awk "BEGIN { u = 100 - $IDLE; if (u < 0) u = 0; printf \"%.0f\", u }")"

sketchybar --set "$NAME" label="${USAGE}%"
