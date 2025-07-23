-- ╔══════════════════════════════════════════════════════╗
-- ║                                                      ║
-- ║  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ║
-- ║  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ║
-- ║  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ║
-- ║  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ║
-- ║  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ║
-- ║  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ║
-- ║                                                      ║
-- ╚══════════════════════════════════════════════════════╝

-- ========================================================
-- Global Variables Config
-- ========================================================
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- ========================================================
-- Load Modules
-- ========================================================
require("config.options") -- Vim options and settings
require("config.keymaps") -- Key mappings
require("config.autocmds") -- Autocommands
require("config.lazy") -- lazy.nvim setup

-- ========================================================
-- Load lazy.nvim Plugin Manager
-- ========================================================
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require("lazy").setup("plugins")
