if not status is-interactive
    exit
end

# tide prompt
set -gx tide_git_icon ""
set -gx tide_private_mode_icon "󰗹 "
set -gx tide_git_truncation_length 0

if not contains private_mode $tide_left_prompt_items
    set -p tide_left_prompt_items private_mode
end
set tide_pwd_color_dirs blue

# chezmoi item
if not contains chezmoi $tide_right_prompt_items
    set -a tide_right_prompt_items chezmoi
end
set -gx tide_chezmoi_bg_color normal
set -gx tide_chezmoi_color yellow
