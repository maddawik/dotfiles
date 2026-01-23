status is-interactive || exit

function _expand_dot_bang_keybindings --on-variable fish_key_bindings
    set -l modes
    if test "$fish_key_bindings" = fish_default_key_bindings
        set modes default insert
    else
        set modes insert default
    end

    bind --mode $modes[1] '.' _expand_dot
    bind --mode $modes[1] '!' _expand_bang
    bind --mode $modes[2] --erase '.' '!'
end

_expand_dot_bang_keybindings
