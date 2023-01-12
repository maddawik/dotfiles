# dots

These are my dotfiles, managed using [chezmoi](https://www.chezmoi.io/)

## Setup

With chezmoi:

```sh
chezmoi init Mawdac
```

Batteries included:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply Mawdac
```

Transitory environments:

```sh
# Install dotfiles - then remove chezmoi, its source-dir and its config-dir
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot Mawdac
```

1Password integration:

```sh
eval $(op signin)
```
