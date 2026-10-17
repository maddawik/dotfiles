status is-interactive || exit

init_xdg

# general env
set -gx SHELL $(which fish)
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
set -gx BAT_THEME tokyonight

# nvm.fish activates this on startup; a major version picks the newest installed
set -q nvm_default_version; or set -g nvm_default_version 26

set -gx fish_color_valid_path green

set -gx fish_transient_prompt 1
