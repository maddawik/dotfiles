status is-interactive || exit

function reload; exec fish $argv; end

# fancy pants
function git --wraps hub; hub $argv; end
function vim --wraps nvim; nvim $argv; end
function ls --wraps eza; eza --icons --group-directories-first $argv; end
abbr nv nvim
abbr yless 'jless --yaml'

# copy/pasta
function c --wraps pbcopy; pbcopy $argv; end
function v --wraps pbpaste; pbpaste $argv; end

# ls shortcuts
function l --wraps ls; ls $argv; end
abbr lla ls -al
abbr lt ls --tree
abbr lt2 ls --tree --level=2
abbr lt3 ls --tree --level=3
abbr lt4 ls --tree --level=4
abbr lt5 ls --tree --level=5

# tmux
abbr tm tmux
abbr tma tmux at
abbr tml tmux ls

# git
abbr ga git add
abbr gd git diff
abbr gf git fetch
abbr gp git pull
abbr gP git push
abbr gs git status
abbr gco git checkout
abbr gsw git switch
abbr gbr git switch -c
abbr --set-cursor='%' gc 'git commit -m "%"'
abbr gca git commit --amend --allow-empty --allow-empty-message --no-edit

abbr --command git l 'log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
abbr --command git ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
abbr --command git lll 'log -u'
abbr --command git t 'log --graph --abbrev-commit --decorate --oneline'
abbr --command git bc 'clone --bare'

# github cli
abbr ghb gh browse
abbr ghd gh dash
abbr ghp gh pr create --assignee @me
abbr --set-cursor='%' -- ghid 'gh issue develop % --checkout'

# dotfiles
abbr cm chezmoi
abbr cma chezmoi add
abbr cmA chezmoi -v apply
abbr cmc chezmoi cd ~
abbr cmd chezmoi diff
abbr cme chezmoi edit --apply
abbr cmf chezmoi forget
abbr cmr chezmoi re-add
abbr cmR chezmoi remove
abbr cms chezmoi status

# lazygit
function lz --wraps lazygit; lazygit $argv; end
function lzc --wraps lazygit; lz --path ~/.local/share/chezmoi/ $argv; end

# lazydocker
function lzd --wraps lazydocker; lazydocker $argv; end
