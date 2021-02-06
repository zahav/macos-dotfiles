#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Set default MySQL root password and auth type.
mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# Install PHP extensions with PECL
pecl install memcached imagick

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Install Oh My Zsh to manage our zsh configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Link custom dotfiles
ln -s $HOME/.dotfiles/aliases.zsh $HOME/.aliases.zsh
ln -s $HOME/.dotfiles/path.zsh $HOME/.path.zsh
ln -s $HOME/.dotfiles/.gitignore_global $HOME/.gitignore

# Setup extensions for VS Code
code \
--install-extension abusaidm.html-snippets \
--install-extension akamud.vscode-theme-onedark \
--install-extension bmewburn.vscode-intelephense-client \
--install-extension dbaeumer.vscode-eslint \
--install-extension msazurermtools.azurerm-vscode-tools

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
