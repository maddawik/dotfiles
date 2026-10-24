status is-interactive || exit

# godot
function nvg --wraps nvim; nvim --listen /tmp/godot.pipe . $argv; end
