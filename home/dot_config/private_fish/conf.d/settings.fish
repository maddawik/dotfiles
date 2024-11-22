if not status is-interactive
    exit
end

# general env
set -gx TERM xterm-256color # HACK: Come back to this (this works, but feels wrong)
set -gx EDITOR nvim
set -gx MANPAGER "bat --style plain"
set -gx BAT_THEME rose-pine-moon
set -gx TEALDEER_CONFIG_DIR "$HOME/.config/tealdeer"

# soho time
fish_config theme choose "Rosé Pine Moon"

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
    --color=fg:#908caa,bg:#232136,hl:#ea9a97 \
    --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97 \
    --color=border:#44415a,header:#3e8fb0,gutter:#232136 \
    --color=spinner:#f6c177,info:#9ccfd8 \
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa \
    --height=70% --layout=reverse --inline-info \
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


# tide prompt
set -gx tide_git_icon ""
set -gx tide_git_truncation_length 0
if not contains private_mode $tide_right_prompt_items
    set -a tide_right_prompt_items private_mode
end
set tide_pwd_color_dirs blue

# chezmoi item
if not contains chezmoi $tide_right_prompt_items
    set -a tide_right_prompt_items chezmoi
end
set -gx tide_chezmoi_bg_color normal
set -gx tide_chezmoi_color yellow

# terraform & terragrunt
if not test -e "$HOME/.cache/"
    mkdir "$HOME/.cache/"
end
if not test -e "$HOME/.cache/tf-cache/"
    mkdir "$HOME/.cache/tf-cache/"
end
if not test -e "$HOME/.cache/tg-cache/"
    mkdir "$HOME/.cache/tg-cache/"
end

set -gx TF_PLUGIN_CACHE_DIR "$HOME/.cache/tf-cache"
set -gx TERRAGRUNT_DOWNLOAD "$HOME/.cache/tg-cache"
