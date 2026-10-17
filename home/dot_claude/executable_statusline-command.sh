#!/bin/bash
# Claude Code statusLine script
# Renders: <dir> | <model> | ctx <used%> | <cost>

input=$(cat)

# 1. Current working directory (basename)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_name=$(basename "$cwd" 2>/dev/null)
[ -z "$dir_name" ] && dir_name="?"

# 3. Model display name
model=$(printf '%s' "$input" | jq -r '.model.display_name // "unknown"')

# 4. Context usage percentage
#    Prefer the precomputed used_percentage field; fall back to computing
#    it from total_input_tokens / context_window_size if that's absent.
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
if [ -z "$used_pct" ] || [ "$used_pct" = "null" ]; then
  total_input=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
  window_size=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
  if [ -n "$total_input" ] && [ -n "$window_size" ] && [ "$window_size" != "0" ] && [ "$window_size" != "null" ]; then
    used_pct=$(awk -v a="$total_input" -v b="$window_size" 'BEGIN{printf "%.0f", (a/b)*100}')
  fi
fi
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  ctx_str=$(awk -v p="$used_pct" 'BEGIN{printf "%.0f%%", p}')
else
  ctx_str="n/a"
fi

# 5. Session cost in USD
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$cost" ] && [ "$cost" != "null" ]; then
  cost_str=$(awk -v c="$cost" 'BEGIN{printf "$%.2f", c}')
else
  cost_str="n/a"
fi

# Tokyo Night Moon palette (truecolor)
RESET='\033[0m'
BLUE='\033[38;2;130;170;255m'    # #82aaff - dir
MAGENTA='\033[38;2;192;153;255m' # #c099ff - model
GREEN='\033[38;2;195;232;141m'   # #c3e88d - context % (low usage)
YELLOW='\033[38;2;255;199;119m'  # #ffc777 - context % (mid usage)
RED='\033[38;2;255;117;127m'     # #ff757f - context % (high usage)
CYAN='\033[38;2;134;225;252m'    # #86e1fc - cost
COMMENT='\033[38;2;99;109;166m'  # #636da6 - separator
SEP="${COMMENT} | ${RESET}"

# Color-grade + gauge-glyph context usage: green <50%, yellow 50-80%, red >80%
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  ctx_color=$(awk -v p="$used_pct" 'BEGIN{print (p>80)?"red":(p>=50)?"yellow":"green"}')
  ctx_glyph=$(awk -v p="$used_pct" 'BEGIN{print (p>87.5)?"●":(p>62.5)?"◕":(p>37.5)?"◑":(p>12.5)?"◔":"○"}')
  ctx_str="${ctx_glyph} ${ctx_str}"
else
  ctx_color="comment"
fi
case "$ctx_color" in
green) CTX_COLOR="$GREEN" ;;
yellow) CTX_COLOR="$YELLOW" ;;
red) CTX_COLOR="$RED" ;;
*) CTX_COLOR="$COMMENT" ;;
esac

line="${BLUE}${dir_name}${RESET}"
line="${line}${SEP}${MAGENTA}${model}${RESET}"
line="${line}${SEP}${CTX_COLOR}${ctx_str}${RESET}"
line="${line}${SEP}${CYAN}${cost_str}${RESET}"

printf "%b" "$line"
