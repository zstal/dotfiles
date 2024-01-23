#!/bin/bash

set -euo pipefail

#
# This script bootstraps a fresh macOS install from scratch
#

# clear all icons from the dock
defaults write com.apple.dock persistent-apps -array

echo '🔄 Installing dotfiles via dotbot...'
./install-dotfiles

echo '🔄 Installing homebrew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo '🔄 Installing CLI tools via homebrew...'
/opt/homebrew/bin/brew bundle install --file homebrew/cli.brewfile --verbose

echo '🔄 Installing GUI apps via homebrew...'
/opt/homebrew/bin/brew bundle install --file homebrew/app.brewfile --verbose

echo '🔄 Associating extensions with apps...'
/opt/homebrew/bin/duti -v defaults/Dutifile

echo '🔄 Tweaking macOS config...'
./defaults/macsetup.sh
