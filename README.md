# My macOS Setup & Dotfiles

Your dotfiles are how you can setup and maintain your Mac. It takes the effort out of installing everything manually. Feel free to copy parts for your own dotfiles and personalise to your own needs. Enjoy! :smile:

## Setting up your Mac

#### 1. Update macOS to the latest version

```bash
sudo softwareupdate -i -a

# Reboot after update
sudo softwareupdate -i -a --reboot
```

#### 2. Install macOS Command Line Tools

```bash
xcode-select --install
```
> The Xcode Command Line Tools includes `git` and `make` (not available on stock macOS).

#### 3. Restore (or generate) the GPG key

- On old system, create a backup of a GPG key
  - `gpg --list-secret-keys`
  - `gpg --export-secret-keys {{KEY_ID}} > /tmp/private.key`
- On new system, import the key:
  - `gpg --import /tmp/private.key`
- Delete the `/tmp/private.key` on both sides

#### 4. Setup Git

```bash
# Set the git author email and username
email="EMAIL"
username="USERNAME"
gpgkeyid="KEY_ID"

# Configure Git
git config --global user.email "${email}"
git config --global user.name "${username}"
git config --global user.signingkey "${gpgkeyid}"
git config --global commit.gpgsign true
git config --global core.excludesfile $HOME/.gitignore

# Create a Code directory for all our work
mkdir $HOME/Code

# Generate a new key
ssh-keygen -t rsa -b 4096 -C "${email}" -f github_rsa

# Start ssh-agent and add the key to it
eval $(ssh-agent -s)
ssh-add $HOME/.ssh/github_rsa

# Display the public key ready to be copy pasted to GitHub
cat $HOME/.ssh/github_rsa.pub
```

- [Add the generated key to GitHub](https://github.com/settings/ssh/new)

#### 5. Finally clone the repository
```bash
mkdir $HOME/.dotfiles
git clone git@github.com:zahav/macos-dotfiles.git $HOME/.dotfiles
```

> Note: you can use a different location than `~/.dotfiles` if you want. Just make sure you also update the reference in the [`.zshrc`](./.zshrc) file.

#### 6. Setup the development environment
```bash
cd $HOME/.dotfiles
sh install.sh
```

Your Mac is now ready to use!