#!/usr/bin/env bash

#
# This script bootstraps a new macOS install.
#

echo 'Installing build tools if not available...'
xcode-select -p || xcode-select --install

echo 'Installing oh-my-zsh...'
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo 'Installing dotfiles via dotbot...'
./dotbot.sh

echo 'Installing homebrew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'Installing CLI tools & apps via homebrew'
brew bundle

echo 'Associating extensions with apps...'
duti Dutifile

echo 'Setting up macOS preferences...'
./macsetup.sh
