if status is-interactive
    # env
    set -gx EDITOR nvim
    set -gx MANPAGER bat

    # vi-mode
    bind --user -M insert jk \
        "if commandline -P; commandline -f cancel; \
        else; set fish_bind_mode default; \
        commandline -f backward-char repaint-mode; end"

    # tide prompt
    set -gx tide_left_prompt_items os pwd git newline character
    set -gx tide_right_prompt_items status cmd_duration context jobs time \
        newline node virtual_env rustc java go terraform aws private_mode
    set -gx tide_git_icon ""

    # fzf
    set -gx FZF_DEFAULT_OPTS "--height=70% --layout=reverse --inline-info \
        --bind 'ctrl-f:preview-half-page-down' \
        --bind 'ctrl-b:preview-half-page-up' \
        --bind 'tab:toggle'"

    # fzf.fish
    fzf_configure_bindings --directory=\cf \
      --git_log=\cg --git_status=\cs --processes=\cp

    # rbenv
    rbenv init - fish | source

    # pyenv
    pyenv init - | source

    # 1password
    op completion fish | source
end

# alias and abbr
source ~/.config/fish/alias.fish
