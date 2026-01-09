#!/usr/bin/env sh

STATE_FILE="/tmp/sketchybar.${NAME}.hover"

VM="$(vm_stat)"
PAGE_SIZE="$(echo "$VM" | head -n 1 | awk '{print $8}' | tr -d '.')"
TOTAL_BYTES="$(sysctl -n hw.memsize)"

ACTIVE="$(echo "$VM" | awk '/Pages active/ {gsub("\\.","",$3); print $3}')"
WIRED="$(echo "$VM" | awk '/Pages wired down/ {gsub("\\.","",$4); print $4}')"
COMP="$(echo "$VM" | awk '/Pages occupied by compressor/ {gsub("\\.","",$5); print $5}')"

USED_PAGES=$((ACTIVE + WIRED + COMP))
USED_BYTES=$((USED_PAGES * PAGE_SIZE))

PCT="$(awk "BEGIN { printf \"%.0f\", ($USED_BYTES/$TOTAL_BYTES)*100 }")"
USED_GB="$(awk "BEGIN { printf \"%.1f\", $USED_BYTES/1024/1024/1024 }")"
TOTAL_GB="$(awk "BEGIN { printf \"%.0f\", $TOTAL_BYTES/1024/1024/1024 }")"

case "$SENDER" in
mouse.entered)
  : >"$STATE_FILE"
  ;;
mouse.exited | mouse.exited.global)
  rm -f "$STATE_FILE"
  ;;
esac

if [ -f "$STATE_FILE" ]; then
  sketchybar --set "$NAME" label="${USED_GB}/${TOTAL_GB}G"
else
  sketchybar --set "$NAME" label="${PCT}%"
fi
