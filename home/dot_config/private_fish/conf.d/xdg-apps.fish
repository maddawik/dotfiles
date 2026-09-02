status is-interactive || exit

# Point CLI tools at XDG base dirs instead of cluttering $HOME.
# Base XDG_* dirs are set by init_xdg in conf.d/00-init.fish; this only maps
# per-app vars. Each block is guarded so missing tools are skipped (don't
# `return` here: this is one file, an early return would skip every block
# below it).

# readline (no command to guard on)
set -q INPUTRC; or set -gx INPUTRC $XDG_CONFIG_HOME/readline/inputrc

if type -q aws
    set -q AWS_SHARED_CREDENTIALS_FILE; or set -gx AWS_SHARED_CREDENTIALS_FILE $XDG_CONFIG_HOME/aws/credentials
    set -q AWS_CONFIG_FILE; or set -gx AWS_CONFIG_FILE $XDG_CONFIG_HOME/aws/config
end

if type -q docker
    set -q DOCKER_CONFIG; or set -gx DOCKER_CONFIG $XDG_CONFIG_HOME/docker
end

if type -q gpg
    set -q GNUPGHOME; or set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
    test -d $GNUPGHOME; or mkdir -p $GNUPGHOME
end

if type -q kubectl
    set -q KUBECONFIG; or set -gx KUBECONFIG $XDG_CONFIG_HOME/kube/config
    set -q KUBECACHEDIR; or set -gx KUBECACHEDIR $XDG_CACHE_HOME/kube
end

if type -q less
    set -q LESSKEY; or set -gx LESSKEY $XDG_CONFIG_HOME/lesskey
    set -q LESSHISTFILE; or set -gx LESSHISTFILE $XDG_STATE_HOME/lesshst
end

if type -q node
    set -q NODE_REPL_HISTORY; or set -gx NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history
end

if type -q npm
    set -q NPM_CONFIG_USERCONFIG; or set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
    set -q NPM_CONFIG_CACHE; or set -gx NPM_CONFIG_CACHE $XDG_CACHE_HOME/npm
end

if type -q psql
    set -q PSQLRC; or set -gx PSQLRC $XDG_CONFIG_HOME/pg/psqlrc
    set -q PSQL_HISTORY; or set -gx PSQL_HISTORY $XDG_STATE_HOME/pg/psql_history
    set -q PGPASSFILE; or set -gx PGPASSFILE $XDG_CONFIG_HOME/pg/pgpass
    set -q PGSERVICEFILE; or set -gx PGSERVICEFILE $XDG_CONFIG_HOME/pg/pg_service.conf
    test -d $XDG_STATE_HOME/pg; or mkdir -p $XDG_STATE_HOME/pg
end

if type -q python3
    set -q WORKON_HOME; or set -gx WORKON_HOME $XDG_DATA_HOME/venvs
    set -q PYLINTHOME; or set -gx PYLINTHOME $XDG_CACHE_HOME/pylint
    set -q IPYTHONDIR; or set -gx IPYTHONDIR $XDG_CONFIG_HOME/ipython
    set -q PYTHON_HISTORY; or set -gx PYTHON_HISTORY $XDG_STATE_HOME/python_history
end

if type -q rg
    set -q RIPGREP_CONFIG_PATH; or set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config
end

if type -q sqlite3
    set -q SQLITE_HISTORY; or set -gx SQLITE_HISTORY $XDG_STATE_HOME/sqlite_history
end

if type -q tmux
    set -q TMUX_CONFIG; or set -gx TMUX_CONFIG $XDG_CONFIG_HOME/tmux/tmux.conf
end

if type -q wget
    set -q WGETRC; or set -gx WGETRC $XDG_CONFIG_HOME/wgetrc
end