# Dotfiles (chezmoi)

Source root is `home/` (see `.chezmoiroot`). Public repo: never commit secrets,
work hostnames, or `~/.ssh/config`.

## Conventions

- Commits: one-line conventional message (`feat:`, `fix:`, `chore:`, `docs:`),
  no body, no AI attribution lines.
- Scripts live in `home/.chezmoiscripts/darwin/` and run alphabetically after
  files are written: install-packages → macos-defaults → setup-fish-plugins →
  setup-gh-extensions → setup-gpg → setup-sudo-touchid → start-services →
  vault-sync-*. Templates render *before* any script runs, so
  a template can't see a tool a script installs in the same apply.
- Package lists are in `run_onchange_after_install-packages.sh.tmpl`, gated by
  the profile flags below. Every tap line carries `trusted: true` (Homebrew
  requires it for third-party taps).

## Machine profiles

`home/.chezmoi.toml.tmpl` sets `work`, `personal`, `ephemeral` and `hostname`
(via `scutil`, since `.chezmoi.hostname` follows DHCP on macOS). Known
hostnames are pre-answered; others get two prompts. `chezmoi init` re-asks.
To simulate prompts: `chezmoi execute-template --init --promptBool "Work machine=true,Personal machine=false"`
(keyed by prompt text, not variable name).

## Fresh machine sequence

1. `xcode-select --install` (dialog may hide behind other windows).
2. One-liner from README. First apply runs over https on purpose: the
   `insteadOf` ssh rewrite in `dot_gitconfig.tmpl` only renders once
   `~/.ssh/id_ed25519` exists.
3. Open 1Password, sign in to the personal account, enable
   Settings → Developer → "Integrate with 1Password CLI".
4. `chezmoi apply` writes the GitHub key from `op://dev/ssh github` (personal
   account, `my.1password.com`). `.ssh` is ignored until `op` is on PATH.
5. `chezmoi apply` again turns the ssh rewrite on.

If git ever wants ssh before the key exists: `GIT_CONFIG_GLOBAL=/dev/null chezmoi apply`.

## Known gotchas

- Fish plugins (tide, fzf.fish, z, nvm) come from fisher, bootstrapped by
  `setup-fish-plugins`. Tide layout is applied with `tide configure --auto`;
  this tide fork has no `--transient` flag.
- sketchybar fonts: `font-hack-nerd-font` and `font-sketchybar-app-font` casks;
  `icon_map.sh` is a chezmoi external. Restart sketchybar after fonts land.
- Caps Lock → Control is a hidutil LaunchAgent, not the System Settings mapping.
- Touch ID for sudo lives in `/etc/pam.d/sudo_local`, with `pam-reattach` so it
  works inside tmux. The script asks for the password once to write it.
- Dock is managed with `dockutil`; it skips if dockutil isn't installed yet.

## Status (2026-10-16)

Old machine `mba-vc` is the source of truth for captured defaults. New work
laptop was mid-setup: packages, defaults, ssh key and fish plugins done;
sketchybar font rendering still looked wrong and was being diagnosed.
