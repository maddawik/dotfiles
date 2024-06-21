function _tide_item_chezmoi
    ps -t (tty) | grep -v grep | grep -q "chezmoi cd"
    if test $status -eq 0
        _tide_print_item chezmoi $tide_chezmoi_icon' '
    end
end
