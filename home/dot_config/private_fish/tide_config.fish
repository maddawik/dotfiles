set -gx tide_git_icon ""
set -gx tide_git_truncation_length 0

# private mode
if not contains private_mode $tide_right_prompt_items
    set -a tide_right_prompt_items private_mode
end

# chezmoi
if not contains chezmoi $tide_right_prompt_items
    set -a tide_right_prompt_items chezmoi
end

set -gx tide_chezmoi_icon ''
set -gx tide_chezmoi_bg_color normal
set -gx tide_chezmoi_color yellow

set tide_pwd_color_dirs blue
