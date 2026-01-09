#!/usr/bin/env sh

# Examples:
# FMT="+%a %b %-d  %-I:%M %p"   # Thu Jan 8  1:05 PM
# FMT="+%Y-%m-%d %H:%M"         # 2026-01-08 13:05
# FMT="+%b %-d · %H:%M:%S"      # Jan 8 · 13:05:44
# FMT="+%m/%d %H:%M"            # 01/08 13:05

FMT="+%a %b %-d %-I:%M %p"

sketchybar --set "$NAME" label="$(date "$FMT")"
