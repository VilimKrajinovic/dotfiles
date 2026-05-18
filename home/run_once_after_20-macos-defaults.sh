#!/bin/sh
# macOS system defaults — runs once on a new machine.
# Some keys (Accessibility, Full Disk Access, Touch ID for sudo) cannot be set via `defaults`
# and must be configured manually in System Settings.

set -e

if [ "$(uname)" != "Darwin" ]; then
  echo "Not macOS — skipping defaults"
  exit 0
fi

echo "==> Applying macOS defaults"

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock tilesize -int 48

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Screenshots
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# Trackpad scroll direction (natural off)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

killall Dock Finder SystemUIServer 2>/dev/null || true

echo "==> Defaults applied. Log out + back in for any keys that need a session refresh."
