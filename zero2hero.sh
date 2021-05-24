#!/usr/bin/env bash

#
# This script bootstraps a fresh macOS install.
#

echo '🔄 Installing build tools if N/A...'
xcode-select --print-path || xcode-select --install

echo '🔄 Tweaking macOS config...'
./defaults/macsetup.sh

echo '🔄 Installing dotfiles via dotbot...'
./dotbot.sh

#
# Package manager
#

echo '🔄 Installing homebrew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#
# CLI tools, apps & default associations
#

echo '🔄 Installing CLI tools via homebrew...'
brew bundle install --file homebrew/cli.brewfile --verbose

echo '🔄 Installing apps via homebrew...'
brew bundle install --file homebrew/app.brewfile --verbose

echo '🔄 Associating extensions with apps...'
duti -v defaults/Dutifile
