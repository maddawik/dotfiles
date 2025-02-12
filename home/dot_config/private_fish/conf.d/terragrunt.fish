if not status is-interactive
    exit
end

# terraform & terragrunt
if not test -e "$HOME/.cache/"
    mkdir "$HOME/.cache/"
end
if not test -e "$HOME/.cache/tf-cache/"
    mkdir "$HOME/.cache/tf-cache/"
end
if not test -e "$HOME/.cache/tg-cache/"
    mkdir "$HOME/.cache/tg-cache/"
end

set -gx TF_PLUGIN_CACHE_DIR "$HOME/.cache/tf-cache"
set -gx TG_DOWNLOAD_DIR "$HOME/.cache/tg-cache"
