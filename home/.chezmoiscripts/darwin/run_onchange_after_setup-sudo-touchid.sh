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

# Never prompt for a password from inside an apply: it fights the pager and
# aborts the whole run on a typo. Only proceed with cached sudo credentials.
if ! sudo -n true 2>/dev/null; then
  echo "setup-sudo-touchid: no cached sudo credentials, skipping." >&2
  echo "setup-sudo-touchid: run 'sudo -v && chezmoi apply' to set up Touch ID for sudo." >&2
  exit 0
fi

echo "setup-sudo-touchid: writing $TARGET"
printf '%s' "$want" | sudo -n tee "$TARGET" >/dev/null
sudo -n chown root:wheel "$TARGET"
sudo -n chmod 444 "$TARGET"
