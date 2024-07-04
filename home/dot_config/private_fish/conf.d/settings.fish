if not status is-interactive
    exit
end

# env
set -gx EDITOR nvim
set -gx MANPAGER "bat --style plain"
set -gx TERM xterm-256color

# vi-mode
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
bind --user -M insert jk \
    "if commandline -P; commandline -f cancel; \
        else; set fish_bind_mode default; \
        commandline -f backward-char repaint-mode; end"
set fish_sequence_key_delay_ms 400

# fzf
set -gx FZF_DEFAULT_OPTS "\
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --height=70% --layout=reverse --inline-info \
    --bind 'ctrl-f:preview-half-page-down' \
    --bind 'ctrl-b:preview-half-page-up' \
    --bind 'ctrl-d:half-page-down' \
    --bind 'ctrl-u:half-page-up'"

# fzf.fish
set -gx fzf_diff_highlighter delta --paging=never --width=20
set -gx fzf_history_time_format "%m-%d-%y %H:%M"
fzf_configure_bindings --directory=\cf \
    --git_log=\cg --git_status=\cs --processes=\cp
set -gx tide_git_icon ""
set -gx tide_git_truncation_length 0

# tide prompt
if not contains private_mode $tide_right_prompt_items
    set -a tide_right_prompt_items private_mode
end

if not contains chezmoi $tide_right_prompt_items
    set -a tide_right_prompt_items chezmoi
end

set -gx tide_chezmoi_icon ''
set -gx tide_chezmoi_bg_color normal
set -gx tide_chezmoi_color yellow

set tide_pwd_color_dirs blue
