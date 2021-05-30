#!/usr/bin/env bash

#
# This script bootstraps a fresh macOS install.
#

echo 'Installing build tools if not available...'
xcode-select --print-path || xcode-select --install

echo 'Installing dotfiles via dotbot...'
./dotbot.sh

echo 'Installing homebrew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'Installing CLI tools & apps via homebrew'
brew bundle --verbose

echo 'Associating extensions with apps...'
duti Dutifile

echo 'Setting up macOS preferences...'
./macsetup.sh
