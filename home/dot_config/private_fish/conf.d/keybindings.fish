status is-interactive || exit

# vi-mode
set --global fish_key_bindings fish_vi_key_bindings
set fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore

# exit insert mode with jk
bind --user -M insert jk \
    "if commandline -P; commandline -f cancel; \
        else; set fish_bind_mode default; \
        commandline -f backward-char repaint-mode; end"
set fish_sequence_key_delay_ms 400 # don't wait after `j` forever!

# fancy-ctrl-z: press ctrl-z again to resume the last backgrounded job
bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'

# copybuffer: ctrl-o copies the current commandline to the clipboard
bind -M insert \co fish_clipboard_copy
bind -M default \co fish_clipboard_copy
