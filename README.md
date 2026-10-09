# macOS dotfiles

My macOS dotfile repo for easy-peasy-lemon-squeezy dotfiles setup. With Tokyo Night theme!

## Requirements

Ensure you have the following installed on your system.

### Stow
```bash
brew install stow
```

### Neovim

Install Neovim and the tools that are intentionally managed outside Mason:

```bash
brew install neovim tree-sitter swiftformat swiftlint
```

The Swift configuration also requires Xcode for `sourcekit-lsp`. Mason installs LuaLS, Prettier, Pyright, Ruff, StyLua, and shfmt when Neovim starts.

## Configurations

We will be creating symlinks for the following dotfile configurations:

- bat       ➜ `~/.config/bat/config`
- bat       ➜ `~/.config/bat/themes/tokyonight_night.tmTheme`
- bat       ➜ `~/.config/bat/themes/tokyonight_day.tmTheme`
- ghostty   ➜ `~/.config/ghostty/config`
- mise      ➜ `~/.config/mise/config.toml`
- neovim    ➜ `~/.config/nvim/init.lua`
- opencode  ➜ `~/.config/opencode/cli.json`
- starship  ➜ `~/.config/starship.toml`
- tmux      ➜ `~/.config/tmux/.tmux.conf`
- zsh       ➜ `~/.zshrc`

## The setup

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
- `~/.config/tmux`

Installing `mise`, `neovim`, `opencode` via `brew` should create the directories for you. Manually create the rest:

```bash
mkdir -p ~/.config/bat/themes ~/.config/ghostty ~/.config/tmux
```

### bat - a better cat with Tokyo Night!
bat automatically selects `tokyonight_night` or `tokyonight_day` based on macOS appearance, including in pipelines and fzf previews. After installing the theme files, rebuild bat's binary cache and verify both themes are available:

```bash
bat cache --build
bat --list-themes
```

### tmux plugin manager

Before you load in `tmux.conf`, make sure to checkout `tpm` in `./config/tmux`:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

## Last step

Be sure you are in root directory of this repo `~/.dotfiles`.

Use `stow` to create symlinks:

```bash
stow .
```

> [!NOTE]
> If you already have existing config files in `~/.config` or `~/.zshrc`, stow will warn you about conflicts. You'll need to backup and remove the existing files first before running stow.
