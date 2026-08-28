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

if not contains aws_expiry $tide_right_prompt_items
    # Keep it right after the built-in aws item, if present
    set -l i (contains -i aws $tide_right_prompt_items)
    if test -n "$i"
        set tide_right_prompt_items $tide_right_prompt_items[1..$i] aws_expiry $tide_right_prompt_items[(math $i + 1)..-1]
    else
        set -a tide_right_prompt_items aws_expiry
    end
end

set -gx tide_aws_expiry_bg_color $tide_aws_bg_color
set -gx tide_aws_expiry_color $tide_aws_color
set -gx tide_aws_expiry_bg_color_critical normal
set -gx tide_aws_expiry_color_critical red
# seconds remaining below which the item turns red
set -gx tide_aws_expiry_critical_threshold 300
