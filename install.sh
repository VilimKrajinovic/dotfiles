#!/bin/sh
# Fresh-Mac bootstrap. Idempotent — safe to re-run.
#
# Primary use: run AFTER `chezmoi init --apply` already cloned this repo.
# This script lives in the dotfiles repo for documentation + manual re-run.
#
# If invoked on a fresh machine WITHOUT chezmoi yet, see README.md for the
# 6-line bootstrap snippet you copy into terminal.

set -e

GH_USER="VilimKrajinovic"
DOTFILES_REPO="${GH_USER}/dotfiles"

# --- Xcode Command Line Tools ---
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools (accept GUI prompt, then re-run this script)"
  xcode-select --install
  exit 1
fi

# --- Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- chezmoi + gh ---
brew list chezmoi >/dev/null 2>&1 || brew install chezmoi
brew list gh       >/dev/null 2>&1 || brew install gh
brew list git      >/dev/null 2>&1 || brew install git

# --- GitHub auth ---
if ! gh auth status >/dev/null 2>&1; then
  echo "==> Authenticating to GitHub (browser flow)"
  gh auth login -h github.com -p https -w
fi

# --- chezmoi apply ---
if [ ! -d "$HOME/.local/share/chezmoi/.git" ]; then
  echo "==> chezmoi init --apply $DOTFILES_REPO"
  chezmoi init --apply "$DOTFILES_REPO"
else
  echo "==> chezmoi already initialized; running apply"
  chezmoi apply
fi

# --- Default shell ---
BREW_ZSH="$(brew --prefix)/bin/zsh"
if [ -x "$BREW_ZSH" ] && [ "$SHELL" != "$BREW_ZSH" ]; then
  if ! grep -q "^${BREW_ZSH}$" /etc/shells; then
    echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
  fi
  echo "==> Setting default shell to $BREW_ZSH"
  chsh -s "$BREW_ZSH"
fi

cat <<'EOF'

╭─────────────────────────────────────────────────────────╮
│  ✓ Bootstrap complete.                                  │
│                                                         │
│  Manual follow-ups:                                     │
│   • Paste API keys into ~/.config/zsh/secrets.zsh       │
│   • Confirm SSH pubkey is registered on GitHub          │
│   • Sign in: 1Password, browsers, Slack, etc.           │
│   • Log out & back in for any pending macOS defaults    │
│                                                         │
│  Re-run anytime: chezmoi apply                          │
╰─────────────────────────────────────────────────────────╯

EOF
