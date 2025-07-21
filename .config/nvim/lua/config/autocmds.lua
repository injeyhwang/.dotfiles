-- =====================================================
-- Autocommands Configuration
-- =====================================================
-- This file contains all autocommands (vim.api.nvim_create_autocmd) that
-- automatically run on various events like file opening, buffer changes, etc.

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto-detect mise environments when entering directories
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  desc = "Auto-activate mise environments",
  callback = function()
    if vim.fn.executable("mise") == 1 then
      vim.fn.system("mise activate")
    end
  end,
})

-- Set indentation per file type
vim.api.nvim_create_autocmd("FileType", {
  desc = "Set 2-space indentation for web files",
  pattern = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "scss",
    "json",
    "yaml",
    "yml",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Set 4-space indentation for Python",
  pattern = { "python" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

-- Modeline: code format config for this file
-- vim: ts=2 sts=2 sw=2 et

