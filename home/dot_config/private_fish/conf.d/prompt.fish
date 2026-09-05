status is-interactive || exit

# Theme
set -q FISH_THEME; or set -U FISH_THEME tokyonight_moon
fish_config theme choose $FISH_THEME
