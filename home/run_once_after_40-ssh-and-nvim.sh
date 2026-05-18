#!/bin/sh
# 1. Ensure local secrets file exists (gitignored, never managed by chezmoi).
# 2. Generate SSH key if missing, prompt user to register with GitHub.
# 3. Clone nvim config from VilimKrajinovic/nvimconf if missing.

set -e

# --- secrets.zsh placeholder ---
SECRETS_DIR="$HOME/.config/zsh"
SECRETS_FILE="$SECRETS_DIR/secrets.zsh"
if [ ! -f "$SECRETS_FILE" ]; then
  mkdir -p "$SECRETS_DIR"
  chmod 700 "$SECRETS_DIR"
  cat > "$SECRETS_FILE" <<'EOF'
# Local secrets — sourced by ~/.zshrc, gitignored, never managed by chezmoi.
# Paste API keys here. This file is per-machine and intentionally not synced.
#
# Example:
#   export ANTHROPIC_API_KEY=sk-ant-...
#   export OPENAI_API_KEY=sk-...
#   export GITHUB_TOKEN=ghp_...
EOF
  chmod 600 "$SECRETS_FILE"
  echo "==> Created placeholder $SECRETS_FILE — paste your API keys when ready."
fi

# --- SSH key ---
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY" ]; then
  EMAIL="{{ .email }}"
  echo "==> Generating SSH key for $EMAIL"
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY" -N ""
  # Add to Apple keychain
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || ssh-add "$SSH_KEY"
  # Copy pubkey to clipboard
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy < "${SSH_KEY}.pub"
    echo "==> Public key copied to clipboard."
  else
    echo "==> Public key contents:"
    cat "${SSH_KEY}.pub"
  fi
  echo "==> Open https://github.com/settings/keys and paste it, then press ENTER to continue."
  read -r _
fi

# --- nvim config ---
NVIM_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_DIR/.git" ]; then
  echo "==> Cloning nvim config (VilimKrajinovic/nvimconf)"
  git clone git@github.com:VilimKrajinovic/nvimconf.git "$NVIM_DIR"
fi

echo "==> SSH and nvim bootstrap complete."
