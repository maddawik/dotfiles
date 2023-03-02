if status is-interactive
    # env
    set -gx EDITOR nvim
    set -gx MANPAGER bat

    # fzf
    set -gx FZF_DEFAULT_OPTS "--height=70% --layout=reverse --inline-info \
      --bind 'ctrl-f:preview-half-page-down' 
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

    # starship
    starship init fish | source
end

# alias and abbr
source ~/.config/fish/alias.fish
