if not status is-interactive
    exit
end

# general env
set -gx SHELL $(which fish)
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
set -gx BAT_THEME tokyonight
set -gx TEALDEER_CONFIG_DIR "$HOME/.config/tealdeer"
set -gx EZA_CONFIG_DIR "$HOME/.config/eza"

fish_config theme choose tokyonight_moon

# vi-mode
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# exit insert mode with jk
bind --user -M insert jk \
    "if commandline -P; commandline -f cancel; \
        else; set fish_bind_mode default; \
        commandline -f backward-char repaint-mode; end"
set fish_sequence_key_delay_ms 400 # don't wait after `j` forever!

# fzf
set -gx FZF_DEFAULT_OPTS "\
    --highlight-line \
    --info=inline-right \
    --height=70% \
    --ansi \
    --layout=reverse \
    --border=none
    --color=bg+:#2d3f76 \
    --color=bg:#1e2030 \
    --color=border:#589ed7 \
    --color=fg:#c8d3f5 \
    --color=gutter:#1e2030 \
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
fzf_configure_bindings --directory=\cf --git_log=\cg \
    --git_status=\cs \
    --processes=\cp \
    --variables=\cv
