if not status is-interactive
    exit
end

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

# k8s
alias k kubectl
