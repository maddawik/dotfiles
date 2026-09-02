function fprof --description 'Profile fish startup'
    test -d $XDG_CACHE_HOME/fish; or mkdir -p $XDG_CACHE_HOME/fish
    fish --profile-startup=$XDG_CACHE_HOME/fish/fishprof.txt -c exit
    cat $XDG_CACHE_HOME/fish/fishprof.txt
end