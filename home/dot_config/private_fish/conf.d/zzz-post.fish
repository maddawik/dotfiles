status is-interactive || exit

fzf_configure_bindings --directory=\cf --git_log=\cg \
    --git_status=\cs \
    --processes=\cp \
    --variables=\cv