# macOS dotfiles

My macOS dotfile repo for easy-peasy-lemon-squeezy dotfiles setup.

## requirements

Ensure you have the following installed on your system.

### Stow

```bash
$ brew install stow
```

## configurations

We will be configuring the following dotfile configurations:
- ghostty   ➜ `~/.config/ghostty/config`
- mise      ➜ `~/.config/mise/config.toml`
- neovim    ➜ `~/.config/nvim/init.lua`
- starship  ➜ `~/.config/starship.toml`
- tmux      ➜ `~/.config/tmux/.tmux.conf`
- zsh       ➜ `.zshrc`

## installation

First checkout the dotfiles repo in your $HOME directory using git

```bash
$ git clone https://github.com/injeyhwang/dotfiles.git
$ cd dotfiles
```

Then use `stow` to create symlinks

```bash
$ stow .
```

