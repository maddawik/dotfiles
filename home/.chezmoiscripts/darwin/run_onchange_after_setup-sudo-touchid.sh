#!/bin/bash
# Touch ID for sudo via /etc/pam.d/sudo_local, which survives macOS updates
# (unlike edits to /etc/pam.d/sudo). pam_reattach lets the prompt work inside
# tmux; without it pam_tid can't reach the GUI session and falls back to the
# password. Both lines fall through to the password if Touch ID is unavailable.
set -eufo pipefail

REATTACH=/opt/homebrew/lib/pam/pam_reattach.so
TARGET=/etc/pam.d/sudo_local

want="# Managed by chezmoi (setup-sudo-touchid)
"
if [[ -f "$REATTACH" ]]; then
  want+="auth       optional       $REATTACH ignore_ssh
"
else
  echo "setup-sudo-touchid: pam-reattach not installed, Touch ID won't work in tmux" >&2
fi
want+="auth       sufficient     pam_tid.so
"

if [[ -f "$TARGET" ]] && [[ "$(cat "$TARGET")" == "${want%$'\n'}" ]]; then
  echo "setup-sudo-touchid: already configured"
  exit 0
fi

echo "setup-sudo-touchid: writing $TARGET (needs sudo)"
printf '%s' "$want" | sudo tee "$TARGET" >/dev/null
sudo chown root:wheel "$TARGET"
sudo chmod 444 "$TARGET"
