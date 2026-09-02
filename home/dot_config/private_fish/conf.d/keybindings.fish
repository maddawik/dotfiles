status is-interactive || exit

# fancy-ctrl-z: press ctrl-z again to resume the last backgrounded job
bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'

# copybuffer: ctrl-o copies the current commandline to the clipboard
bind -M insert \co fish_clipboard_copy
bind -M default \co fish_clipboard_copy

# Fire a preexecute event before a command runs, so hooks below can
# rewrite the commandline first.
function _preprocess_commandline --description 'Emit preexecute event before running a command'
    emit preexecute (commandline)
    commandline -f execute
end

bind -M insert \r _preprocess_commandline
bind -M default \r _preprocess_commandline

# magic-enter: pressing enter on an empty commandline runs a default command
function magic-enter --on-event preexecute --description 'Run a default command when enter is pressed on an empty line'
    set -l cmd (commandline)
    if test -z "$cmd"
        set -l default_cmd ls
        if command git rev-parse --is-inside-work-tree &>/dev/null
            set default_cmd 'git status -sb'
        end
        commandline -r $default_cmd
    end
end

# strip-dollar-prefix: strip a leading "$ " when pasting copied shell commands
function strip_dollar_prefix --on-event preexecute --description 'Strip a leading "$ " when pasting copied shell commands'
    set -l cmd (commandline)
    if string match -qr '(^|\n)\$ ' -- $cmd
        commandline -r -- (string replace -ar '(^|\n)\$ ' '$1' -- $cmd)
    end
end