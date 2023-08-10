if status is-interactive
    # env
    set -gx EDITOR nvim
    set -gx MANPAGER bat

    # vi-mode
    set fish_vi_force_cursor 1
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    bind --user -M insert jk \
        "if commandline -P; commandline -f cancel; \
        else; set fish_bind_mode default; \
        commandline -f backward-char repaint-mode; end"

    # fzf
    set -gx FZF_DEFAULT_OPTS \
        "--color=fg:#c0caf5,hl:#ff9e64 \
        --color=fg+:#c0caf5,hl+:#ff9e64 \
        --color=info:#7aa2f7,prompt:#7aa2f7,pointer:#db4b4b \
        --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a \
        --height=70% --layout=reverse --inline-info \
        --bind 'ctrl-f:preview-half-page-down' \
        --bind 'ctrl-b:preview-half-page-up' \
        --bind 'tab:toggle'"

    # fzf.fish
    set -gx fzf_history_time_format "%m-%d-%y %H:%M"
    fzf_configure_bindings --directory=\cf \
        --git_log=\cg --git_status=\cs --processes=\cp

    # pnpm
    set -gx PNPM_HOME "$HOME/Library/pnpm"

    # rbenv
    rbenv init - fish | source

    # pyenv
    pyenv init - | source

    # 1password
    op completion fish | source

    # starship
    starship init fish | source
end

# alias and abbr
source ~/.config/fish/alias.fish
