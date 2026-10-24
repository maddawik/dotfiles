# Setup

Notes for bringing up a new Mac. Back to the [README](README.md).

## Machine profiles

`chezmoi init` asks two questions on a host it doesn't recognise:

- **Work machine**: adds aws/k8s/terraform tooling, Slack, Teams, Zoom, Pritunl
- **Personal machine**: adds Discord, Plex, OBS

Both can be yes. Known hostnames are pre-answered in `.chezmoi.toml.tmpl`;
re-run `chezmoi init` to change an answer. Containers, codespaces and
non-interactive runs are treated as ephemeral: no GUI apps, no launch agents.

## New machine

The first apply runs over https on purpose: the ssh URL rewrite in
`.gitconfig` only switches on once `~/.ssh/gh_rsa.pub` exists, and that
comes from 1Password. So the order is:

1. `xcode-select --install` (chezmoi needs `git`; macOS only ships a stub).
2. The batteries-included one-liner from the README. It installs Homebrew,
   packages (including the 1Password app and CLI), macOS defaults and fish
   plugins.
3. Open 1Password, sign in to the personal account, and turn on
   Settings → Developer → "Integrate with 1Password CLI" and "Use the SSH
   agent".
4. `chezmoi apply` again. It writes the ssh public keys and the agent config,
   and imports the GPG signing key from 1Password. Private ssh keys stay in
   1Password.
5. `chezmoi apply` once more. The gitconfig now rewrites GitHub to ssh.
6. `gh auth login`, then `sudo -v && chezmoi apply`. This installs the gh
   extensions and enables Touch ID for sudo (that script skips unless sudo
   credentials are cached).

## Still manual

- `~/.ssh/config.local`: host entries (kept out of the repo). Point each
  `IdentityFile` at a `.pub` and set `IdentitiesOnly yes`.
- vault-sync deploy keys, one per vault:
  `ssh-keygen -t ed25519 -N '' -C "vault-sync@$(scutil --get LocalHostName) <vault>" -f ~/.ssh/vault-sync-<vault>`,
  then `gh repo deploy-key add ~/.ssh/vault-sync-<vault>.pub --allow-write -R <owner>/<repo> -t "vault-sync <host>"`.

- Raycast: Confirm the hotkey is `cmd+space` (Spotlight's is disabled)
- Ghostty / AeroSpace / Shottr / BetterDisplay / Raycast: grant Accessibility
  and Screen Recording when prompted
- Energy: `sudo pmset -b displaysleep 2 && sudo pmset -c displaysleep 10`
- Software Update: turn on automatic macOS updates
- Default browser: pick Brave when it first launches
