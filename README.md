# Dotfiles

A structured dotfiles repository for managing Linux/WSL configurations using GNU Stow.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Structure](#structure)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications. It uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks, making it easy to deploy and maintain configurations across multiple machines.

### What is GNU Stow?

GNU Stow is a symlink farm manager that makes it easy to install and uninstall software packages or configuration files. It creates symlinks from a source directory to a target directory (typically your home directory).

### Why GNU Stow?

- **Simple**: Easy to understand and use
- **Portable**: Works on any Unix-like system
- **Flexible**: Install or uninstall individual configurations
- **Safe**: Easy to revert changes without losing data
- **Version Control**: Keep all configs in one Git repository

## 🔧 Prerequisites

Before using this repository, ensure you have the following installed:

```bash
# On Debian/Ubuntu
sudo apt update
sudo apt install git stow

# On Fedora/RHEL
sudo dnf install git stow

# On Arch Linux
sudo pacman -S git stow

# On macOS (with Homebrew)
brew install git stow
```

## 📥 Installation

1. **Clone this repository** to your home directory:

```bash
git clone https://github.com/MyrrdinAlsatian/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **Install all configurations** at once:

```bash
make install
# or
make link
```

3. **Install specific configurations** (optional):

```bash
make link-git      # Install only git configuration
make link-zsh      # Install only zsh configuration
make link-tmux     # Install only tmux configuration
make link-starship # Install only starship configuration
make link-ssh      # Install only ssh configuration
```

## 🚀 Usage

### Available Make Commands

```bash
make help      # Show all available commands
make install   # Install all dotfiles (create symlinks)
make link      # Alias for install
make unlink    # Remove all symlinks
make update    # Pull latest changes and reinstall
make clean     # Remove broken symlinks
```

### Manual Stow Usage

If you prefer to use `stow` directly:

```bash
# Install a specific package
stow -t $HOME git

# Remove a specific package
stow -D -t $HOME git

# Reinstall a package
stow -R -t $HOME git

# Dry run (see what would happen without making changes)
stow -n -v -t $HOME git
```

### SSH Configuration

The SSH configuration requires special handling:

```bash
# SSH config goes to ~/.ssh/ directory
mkdir -p ~/.ssh
stow -t ~/.ssh ssh
chmod 600 ~/.ssh/config
```

## 📁 Structure

```
dotfiles/
├── git/
│   └── .gitconfig           # Git configuration
├── zsh/
│   └── .zshrc               # Zsh shell configuration
├── tmux/
│   └── .tmux.conf           # Tmux terminal multiplexer config
├── starship/
│   └── .starship.toml       # Starship prompt configuration
├── ssh/
│   └── config               # SSH client configuration
├── shared/                  # Shared shell configuration
│   ├── .aliases             # Shell aliases (cross-shell compatible)
│   ├── .exports             # Environment variables
│   ├── .functions           # Custom shell functions
│   ├── .env.sh              # Loader script for all shared configs
│   ├── .local               # Local overrides (gitignored)
│   └── bin/                 # Utility scripts
│       ├── sysinfo          # Display system information
│       ├── git-status-all   # Check status of multiple git repos
│       ├── backup           # Backup files and directories
│       ├── note             # Quick note-taking utility
│       └── check-port       # Check if a port is in use
├── Makefile                 # Automation scripts
├── README.md                # This file
└── .gitignore               # Files to exclude from git
```

### How Stow Works

When you run `stow -t $HOME git`, Stow creates a symlink:
- `~/dotfiles/git/.gitconfig` → `~/.gitconfig`

Each subdirectory (git, zsh, tmux, etc.) is a "package" that Stow can manage independently.

### Shared Configuration

The `shared/` directory contains shell configurations that work across different shells (bash, zsh):

- **`.aliases`**: Common aliases for navigation, git, docker, and more
- **`.exports`**: Environment variables (PATH, EDITOR, history settings)
- **`.functions`**: Useful shell functions (mkcd, extract, backup, etc.)
- **`.env.sh`**: Main loader that sources all shared configs
- **`.local`**: Local overrides (gitignored, for machine-specific settings)
- **`bin/`**: Utility scripts (sysinfo, git-status-all, backup, note, check-port)

The zsh configuration automatically loads these via `.env.sh`.

### Utility Scripts

The `shared/bin/` directory contains useful utility scripts:

- **`sysinfo`**: Display detailed system information
- **`git-status-all`**: Check git status of multiple repositories
- **`backup`**: Easy backup utility for files and directories
- **`note`**: Quick note-taking with timestamps
- **`check-port`**: Check if a port is in use

After installation, these scripts are available in your PATH.

## ✅ Best Practices

### Before Making Changes

1. **Backup existing configurations**:
```bash
cp ~/.gitconfig ~/.gitconfig.backup
cp ~/.zshrc ~/.zshrc.backup
# etc.
```

2. **Test changes locally** before committing to the repository.

### Customization

1. **User-specific settings**: Use local configuration files that are gitignored:
   - `.zshrc.local` for zsh
   - `ssh/config.local` for ssh
   - etc.

2. **Sensitive data**: Never commit:
   - SSH private keys
   - API tokens
   - Passwords
   - Personal email addresses (use placeholders instead)

3. **Git user configuration**: Update `git/.gitconfig` with your information:
```bash
# Edit git/.gitconfig
[user]
    name = Your Name
    email = your.email@example.com
```

### Maintaining Your Dotfiles

1. **Regular updates**:
```bash
cd ~/dotfiles
git pull
make update
```

2. **Adding new configurations**:
```bash
# Create new package directory
mkdir -p ~/dotfiles/newapp
# Move your config file
mv ~/.newapprc ~/dotfiles/newapp/
# Install with stow
stow -t $HOME newapp
# Commit to git
git add newapp
git commit -m "Add newapp configuration"
git push
```

3. **Keep it portable**:
   - Use environment variables when possible
   - Avoid hardcoded paths
   - Use conditional blocks for OS-specific settings

### Version Control Tips

1. **Commit frequently** with clear messages:
```bash
git commit -m "zsh: Add alias for docker commands"
```

2. **Use branches** for experimental changes:
```bash
git checkout -b experimental-tmux-theme
# Make changes
# Test thoroughly
git checkout main
git merge experimental-tmux-theme
```

3. **Document changes** in commit messages explaining *why*, not just *what*.

## 🐛 Troubleshooting

### Stow Conflicts

If you get a conflict error:

```
WARNING! stowing git would cause conflicts:
  * existing target is not owned by stow: .gitconfig
```

**Solution**: Backup and remove the existing file first:
```bash
mv ~/.gitconfig ~/.gitconfig.backup
make link-git
```

### Symlinks Not Working

Check if symlinks were created:
```bash
ls -la ~ | grep -E '\.gitconfig|\.zshrc|\.tmux\.conf|\.starship\.toml'
```

### SSH Permissions

SSH requires specific permissions:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_* 2>/dev/null || true
chmod 644 ~/.ssh/*.pub 2>/dev/null || true
```

### Stow Not Found

Install GNU Stow:
```bash
# See Prerequisites section above
```

### Undoing Changes

To completely remove all dotfiles:
```bash
make unlink
# Restore your backups
mv ~/.gitconfig.backup ~/.gitconfig
# etc.
```

## 📚 Additional Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [Dotfiles Best Practices](https://dotfiles.github.io/)
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)

## 📝 License

These are personal configuration files. Feel free to use them as inspiration for your own dotfiles!

## 🤝 Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome! Feel free to open an issue or submit a pull request.

---

**Note**: Remember to review and customize these configurations for your specific needs before using them!
