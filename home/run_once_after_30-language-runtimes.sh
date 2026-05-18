#!/bin/sh
# Install default language runtimes: Node LTS, Python 3.13, OpenJDK 11.
# Tools (nvm, pyenv, jenv, openjdk) are installed via Brewfile (run_onchange_10).

set -e

echo "==> Installing language runtimes"

# Node LTS via nvm
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  # shellcheck disable=SC1091
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
else
  echo "nvm not found at $NVM_DIR — install nvm separately (Brewfile usually handles this)"
fi

# Python 3.13 via pyenv
if command -v pyenv >/dev/null 2>&1; then
  pyenv install -s 3.13
  pyenv global 3.13
else
  echo "pyenv not found"
fi

# OpenJDK 11 registered with jenv
if command -v jenv >/dev/null 2>&1 && [ -d /opt/homebrew/opt/openjdk@11 ]; then
  jenv add /opt/homebrew/opt/openjdk@11 2>/dev/null || true
  jenv global 11 2>/dev/null || true
else
  echo "jenv or openjdk@11 missing — skipping java setup"
fi

echo "==> Language runtimes installed"
