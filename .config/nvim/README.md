# Neovim (LazyVim)

This is my personal Neovim setup based on LazyVim.

## Upstream docs
- LazyVim: https://www.lazyvim.org
- Lazy.nvim: https://github.com/folke/lazy.nvim
- Tokyo Night: https://github.com/folke/tokyonight.nvim

## Structure
- `init.lua` — entry point
- `lua/config/` — options, keymaps, autocmds
- `lua/plugins/` — plugin specs/overrides
- `stylua.toml` — Lua formatter config

## My customizations
- Theme: Tokyo Night (Night)
- Plugin overrides live in `lua/plugins/`

## Setup
- Managed via stow from `~/.dotfiles`
- Run `stow .` in `~/.dotfiles` to link into `~/.config/nvim`
