#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Remove outdated versions from the cellar
brew cleanup

# Auto-start the MariaDB Server
brew services start mariadb

# Set default MySQL root password and auth type
mysql_secure_installation

# Install PHP extensions with PECL
pecl install memcached imagick

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Create a Code directory for our projects
mkdir $HOME/Code

# Configuring ignored files for all repositories
git config --global core.excludesfile ~/.dotfiles/.gitignore_global

# Install Oh My Zsh to manage our zsh configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

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
