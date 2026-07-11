#!/bin/bash

#
# This script bootstraps a fresh macOS install
#

set -euo pipefail

# clears the Dock, adds spacers then forces a UI refresh
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock persistent-apps -array
for i in {1..3}; do
  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
done
killall Dock

echo '🔄 Configuring macOS settings...'
./macos/macsetup.sh

echo '🔄 Installing dotfiles...'
./install-dotfiles

echo '🔄 Ensuring homebrew is installed...'
command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo '🔄 Installing CLI tools via homebrew...'
/opt/homebrew/bin/brew bundle install --file homebrew/cli.brewfile --verbose

echo '🔄 Installing GUI apps via homebrew...'
/opt/homebrew/bin/brew bundle install --file homebrew/apps.brewfile --verbose

echo '🔄 Associating extensions with apps...'
/opt/homebrew/bin/duti -v macos/Dutifile
