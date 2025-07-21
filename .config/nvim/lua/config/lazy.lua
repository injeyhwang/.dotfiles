-- =====================================================
-- Lazy.nvim Plugin Manager Configuration
-- =====================================================
-- This file handles the setup and bootstrap of lazy.nvim plugin manager.
-- It ensures lazy.nvim is installed and sets up the plugin loading system.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Modeline: code format config for this file
-- vim: ts=2 sts=2 sw=2 et
