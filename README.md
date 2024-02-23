# dotfiles

These are my configuration files (often called `dotfiles`), managed using
[chezmoi](https://www.chezmoi.io/)

Feel free to use anything you find here for inspiration in your own config. I
do not suggest forking or copy-pasta'ing this repo, as it's catered to my own
tools.

It is primarily intended for use on MacOS as that is my daily driver for
work/home, I occasionally use linux so everything should work there as well,
albeit untested.

## Core tools

- Amethyst (MacOS)
- WezTerm
- Fish shell
- Tmux
- Neovim

## Install

With chezmoi already installed:

```sh
chezmoi init Mawdac
```

Batteries included:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Mawdac
```

Transitory environments (containers):

```sh
# Install dotfiles - then remove chezmoi, its source-dir and its config-dir
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot Mawdac
```

1Password integration:

```sh
eval $(op signin)
```
