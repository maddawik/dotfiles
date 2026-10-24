function init_xdg --description 'Set up XDG base directories'
    set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
    set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
    set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
    set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache
    if not set -q XDG_RUNTIME_DIR
        # macOS gives each user a private TMPDIR under /var/folders, which no
        # one else can create first. /tmp is shared, so it is only a fallback.
        if set -q TMPDIR
            set -gx XDG_RUNTIME_DIR (string trim -r -c / -- $TMPDIR)
        else
            set -gx XDG_RUNTIME_DIR /tmp/xdg-runtime-(id -u)
        end
    end
    for xdgdir in $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME $XDG_RUNTIME_DIR
        test -d $xdgdir; or mkdir -p $xdgdir
    end
    # A runtime dir someone else created is theirs, and sockets in it are
    # readable by them: refuse it rather than use it.
    if not test -O $XDG_RUNTIME_DIR
        echo "init_xdg: $XDG_RUNTIME_DIR is not owned by you, unsetting XDG_RUNTIME_DIR" >&2
        set -e XDG_RUNTIME_DIR
    else
        chmod 700 $XDG_RUNTIME_DIR 2>/dev/null &
    end
end