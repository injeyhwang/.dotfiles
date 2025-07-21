-- =====================================================
-- Plugin List Configuration
-- =====================================================
-- This file contains the main plugin list for lazy.nvim.
-- Individual plugin configurations are split into separate files
-- for better organization and maintainability.

return {
  -- Detect tabstop and shiftwidth automatically
  "NMAC427/guess-indent.nvim",

  -- Git signs in the gutter and utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Load plugin configurations organized by subject (LazyVim style)
  require("plugins.colorscheme"), -- Color scheme configuration
  require("plugins.coding"), -- LSP, completion, debugging
  require("plugins.editor"), -- Telescope, neo-tree, indent guides
  require("plugins.formatting"), -- Code formatting with conform.nvim
  require("plugins.linting"), -- Code linting with nvim-lint
  require("plugins.treesitter"), -- Syntax highlighting and parsing
  require("plugins.ui"), -- UI enhancements, which-key, mini.nvim
}

