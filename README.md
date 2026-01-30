# macOS dotfiles
My macOS dotfile repo for easy-peasy-lemon-squeezy dotfiles setup.

## requirements
Ensure you have the following installed on your system.

### Stow
```bash
brew install stow
```

## configurations
We will be creating symlinks for the following dotfile configurations:
- bat       ➜ `~/.config/bat/config`
- bat       ➜ `~/.config/bat/config/themes/Catppuccin\ Mocha.tmTheme`
- ghostty   ➜ `~/.config/ghostty/config`
- mise      ➜ `~/.config/mise/config.toml`
- neovim    ➜ `~/.config/nvim/init.lua`
- opencode  ➜ `~/.config/opencode/opencode.json`
- tmux      ➜ `~/.config/tmux/.tmux.conf`
- starship  ➜ `~/.config/starship.toml`
- zsh       ➜ `~/.zshrc`

## installation
First checkout the dotfiles repo in your $HOME directory using git:

```bash
git clone https://github.com/injeyhwang/.dotfiles.git
cd .dotfiles
```

Ensure that the following directories exist so that `stow` doesn't symlink entire directories:
- `~/.config/bat/themes`
- `~/.config/ghostty`
- `~/.config/mise`
- `~/.config/nvim`
- `~/.config/opencode`

Installing `mise`, `neovim`, `opencode` via `brew` should create the directories for you. Manually create the rest:

```bash
mkdir -p ~/.config/bat/themes ~/.config/ghostty

```

### bat - a better cat with Tokyo Night!
Once bat theme directory is created, update bat's binary cache and verify if Tokyo Night is available:

```bash
bat cache --build
bat --list-themes
```

Then use `stow` to create symlinks:

```bash
stow .
```

> [!NOTE]
> If you already have existing config files in `~/.config` or `~/.zshrc`, stow will warn you about conflicts. You'll need to backup and remove the existing files first before running stow.

