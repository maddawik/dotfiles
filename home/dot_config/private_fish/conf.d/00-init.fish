status is-interactive || exit

init_xdg

# general env
set -gx SHELL $(which fish)
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
set -gx BAT_THEME tokyonight

set -gx fish_color_valid_path green
