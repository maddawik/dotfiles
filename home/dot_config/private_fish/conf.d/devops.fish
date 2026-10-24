status is-interactive || exit

set -gx TG_DOWNLOAD_DIR "$HOME/.cache/tg-cache"
set -gx TG_PROVIDER_CACHE 1
set -gx TG_PARALLELISM 1

# terragrunt
if not test -e "$HOME/.cache/"
    mkdir "$HOME/.cache/"
end
if not test -e "$HOME/.cache/tg-cache/"
    mkdir "$HOME/.cache/tg-cache/"
end

abbr tf terraform
abbr tg terragrunt

# k8s
function k --wraps kubectl; kubectl $argv; end

# granted: `assume` must be sourced so it can export AWS creds into this shell
function assume --wraps assumego; source (brew --prefix)/bin/assume.fish $argv; end
