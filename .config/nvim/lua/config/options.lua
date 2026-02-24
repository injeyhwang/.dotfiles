-- [[ Global Variables ]]

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Editor Options ]]

-- Make line numbers default
vim.opt.number = true

-- Relative line numbers, to help with jumping
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Use a single global statusline
vim.opt.laststatus = 3

-- Enable auto-write for certain commands and buffer switches
vim.opt.autowrite = true

-- Only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
vim.opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

-- Disable swap files and use persistent undo instead (no more `.swp` when nvim or computer dies)
vim.opt.swapfile = false

-- Save undo history for persistent undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo")

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Better completion behavior
vim.opt.completeopt = "menu,menuone,noselect"

-- Command-line completion mode
vim.opt.wildmode = "longest:full,full"

-- Use 4 spaces instead of tabs by default
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Auto-indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftround = true
vim.opt.smarttab = true

-- Preview substitutions live, without opening a split
vim.opt.inccommand = "nosplit"

-- Sets how neovim will display certain whitespace characters in the editor
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Enable true color support
vim.opt.termguicolors = true

-- Show vertical ruler and soft wrap
vim.opt.colorcolumn = "100"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Put new horizontal splits below and vertical splits to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
