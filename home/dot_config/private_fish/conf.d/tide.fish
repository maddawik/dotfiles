status is-interactive || exit

# tide prompt
set -gx tide_git_icon ""
set -gx tide_private_mode_icon "󰗹"
set -gx tide_git_truncation_length 12
set tide_pwd_color_dirs blue

if not contains private_mode $tide_left_prompt_items
    set -p tide_left_prompt_items private_mode
end
if not contains chezmoi $tide_left_prompt_items
    set -p tide_left_prompt_items chezmoi
end

set -gx tide_chezmoi_bg_color normal
set -gx tide_chezmoi_color yellow
