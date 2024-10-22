function pyplz
    pyenv init - | source
    pyenv virtualenv-init - | source
    set_color brgreen
    echo -n "Pyenv ready!"
    set_color brblue
    echo "  "
end
