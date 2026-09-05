status is-interactive || exit

# Fire a preexecute event before a command runs, so hooks below can
# rewrite the commandline first.
function _preprocess_commandline --description 'Emit preexecute event before running a command'
    # Don't run inside nested read prompts, i.e. default confirmation choices
    if test (status current-command) = fish
        emit preexecute (commandline)
    end
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