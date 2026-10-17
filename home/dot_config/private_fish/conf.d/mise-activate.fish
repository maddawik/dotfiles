# Shadows Homebrew's vendor_conf.d/mise-activate.fish (same filename wins), which
# runs `mise activate fish` on every startup. Shims keep startup free of mise
# calls: tools still switch per project and see [env], but the shell itself
# doesn't get [env] vars or hooks. For full activation in one shell:
#   mise activate fish | source
if type -q mise
    set -l shims (set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo $HOME/.local/share)/mise/shims
    # fish_add_path skips missing dirs, and mise only creates this on first install
    test -d $shims; or mkdir -p $shims
    fish_add_path -gP $shims
end
