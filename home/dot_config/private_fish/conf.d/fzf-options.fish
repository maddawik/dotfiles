status is-interactive || exit

set -gx FZF_DEFAULT_OPTS "\
    --highlight-line \
    --info=inline-right \
    --height=70% \
    --ansi \
    --layout=reverse \
    --border=none \
    --color=bg:-1 \
    --color=gutter:-1 \
    --color=preview-bg:-1 \
    --color=bg+:#2d3f76 \
    --color=border:#589ed7 \
    --color=fg:#c8d3f5 \
    --color=header:#ff966c \
    --color=hl+:#65bcff \
    --color=hl:#65bcff \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#65bcff \
    --color=query:#c8d3f5:regular \
    --color=scrollbar:#589ed7 \
    --color=separator:#ff966c \
    --color=spinner:#ff007c \
    --bind 'ctrl-f:preview-half-page-down' \
    --bind 'ctrl-b:preview-half-page-up' \
    --bind 'ctrl-d:half-page-down' \
    --bind 'ctrl-u:half-page-up'"

# fzf.fish
set -gx fzf_diff_highlighter delta --paging=never --width=20
set -gx fzf_history_time_format "%m-%d-%y %H:%M"
